# frozen_string_literal: true

module Weather
  class FetchDaily < BaseOperation
    def initialize(city:, days: 7)
      super()

      @city = city
      @days = Integer(days).clamp(1, 16)
    end

    def call
      key = cache_key(%w[weather daily] + [@city.cache_key_with_version, @days])

      cache.fetch(key, expires_in: ttl) do
        aggregator.daily(lat: @city.lat, lon: @city.lon, days: @days)
      end
    end
  end
end
