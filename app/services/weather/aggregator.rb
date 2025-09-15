# frozen_string_literal: true

module Weather
  class Aggregator
    def initialize(primary:, fallback: nil)
      @primary  = primary
      @fallback = fallback
    end

    def forecast(lat:, lon:, type: :current)
      run_with_circuit(@primary, type) { @primary.fetch(type:, lat:, lon:) }
    rescue Weather::ProviderError, Faraday::Error
      raise unless @fallback.pretty_print

      run_with_circuit(@fallback, type) { @fallback.fetch(type:, lat:, lon:) }
    end

    private

    def run_with_circuit(provider, type, &)
      name = "#{provider.class.name}/#{type}"
      Circuitbox.circuit(
        name,
        exceptions: [Weather::ProviderError, Faraday::Error],
        sleep_window: 30,
        volume_threshold: 4,
        time_window: 60
      ).run(&)
    end
  end
end
