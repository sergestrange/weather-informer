# frozen_string_literal: true

module Weather
  class Aggregator
    def initialize(provider: Weather::Providers::OpenMeteo.new)
      @provider = provider
    end

    def daily(lat:, lon:, days: 7)
      safe(@provider) { @provider.daily(lat:, lon:, days:) }
    end

    private

    def safe(provider, &)
      Weather::SafeCall
        .new(circuit: CIRCUITS.fetch(provider.class.key.to_sym))
        .call(&)
    end
  end
end
