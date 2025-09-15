# frozen_string_literal: true

module Weather
  ##
  # Aggregator chooses the best available weather provider.
  # It wraps calls with a circuit breaker and optionally falls back
  # to a secondary provider.
  #
  # Example:
  #   primary  = Weather::Providers::OpenMeteo.new
  #   fallback = Weather::Providers::OpenWeather.new(api_key: "...")
  #   agg = Weather::Aggregator.new(primary:, fallback:)
  #   agg.forecast(lat: 52.37, lon: 4.90)
  #
  class Aggregator
    ##
    # @param primary [Weather::Provider]
    #   Main provider that will be queried first.
    #
    # @param fallback [Weather::Provider, nil]
    #   Optional fallback provider used when the primary fails
    #   or its circuit is open.
    #
    # @param name [String]
    #   Circuit breaker identifier (used as key in store).
    #
    def initialize(primary:, fallback: nil, name: 'weather_primary')
      @primary  = primary
      @fallback = fallback
      @circuit  = Circuitbox.circuit(name,
                                     exceptions: [ProviderError, Faraday::Error],
                                     sleep_window: 30,
                                     volume_threshold: 4,
                                     time_window: 60)
    end

    ##
    # Fetches forecast from provider(s).
    #
    # Uses primary provider through circuit breaker.
    # If the breaker is open or primary fails, tries fallback (if provided).
    #
    # @param lat [Float] latitude
    # @param lon [Float] longitude
    #
    # @return [Hash]
    #   - :temperature [Float] current temperature
    #   - :wind_speed  [Float] current wind speed
    #   - :observed_at [Time]  observation time
    #   - :provider    [String] provider id
    #
    # @raise [Weather::ProviderError] if all providers are unavailable
    #
    def forecast(lat:, lon:)
      return call(@primary, lat:, lon:) if @circuit.run { callable?(@primary, lat:, lon:) }

      Rails.logger.info('[weather] primary circuit open, using fallback')
      return call(@fallback, lat:, lon:) if @fallback

      raise ProviderError, 'All providers unavailable'
    rescue ProviderError
      @fallback ? call(@fallback, lat:, lon:) : (raise)
    end

    private

    def callable?(provider, lat:, lon:)
      provider.forecast(lat:, lon:)
    end

    def call(provider, lat:, lon:)
      raise ProviderError, 'No provider configured' unless provider

      provider.forecast(lat:, lon:)
    end
  end
end
