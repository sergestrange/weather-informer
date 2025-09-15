# frozen_string_literal: true

module Weather
  class FetchCurrent < BaseOperation
    def initialize(city:)
      @city = city
    end

    def call
      key = cache_key(%w[weather current] + [@city.cache_key_with_version])

      cache.fetch(key, expires_in: ttl) do
        aggregator.forecast(lat: @city.lat, lon: @city.lon, type: :current)
      end
    end
  end
end
