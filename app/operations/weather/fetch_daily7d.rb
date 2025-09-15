# frozen_string_literal: true

module Weather
  class FetchDaily7d < BaseOperation
    def initialize(city:)
      @city = city
    end

    def call
      key = cache_key(%w[weather daily7d] + [@city.cache_key_with_version])

      cache.fetch(key, expires_in: ttl) do
        aggregator.forecast(lat: @city.lat, lon: @city.lon, type: :daily_7d)
      end
    end
  end
end
