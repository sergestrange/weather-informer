# frozen_string_literal: true

module Weather
  ##
  # Abstract interface for weather providers.
  # Every concrete provider (e.g. OpenMeteo) must
  # implement the {#forecast} method and return normalized data.
  #
  # Example return value:
  #   {
  #     temperature: 18.2,                 # [Float] in °C
  #     wind_speed:  5.1,                  # [Float] in m/s
  #     provider:    "open_meteo",         # [String] provider id
  #     observed_at: Time.parse("2025-09-14T17:00Z") # [Time]
  #   }
  #
  class Provider
    ##
    # Fetches current weather forecast for given coordinates.
    #
    # @param lat [Float] latitude in degrees (-90..90)
    # @param lon [Float] longitude in degrees (-180..180)
    #
    # @return [Hash]
    #   - :temperature [Float] current temperature
    #   - :wind_speed  [Float] current wind speed
    #   - :provider    [String] provider id
    #   - :observed_at [Time] observation timestamp
    #
    # @raise [Weather::ProviderError]
    #   when provider fails to respond or returns invalid data
    # @raise [NotImplementedError]
    #   if subclass does not override this method
    #
    def forecast(lat:, lon:, type:)
      raise NotImplementedError
    end
  end
end
