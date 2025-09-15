# frozen_string_literal: true

module Weather
  module Providers
    class OpenMeteo < Provider
      BASE = 'https://api.open-meteo.com'

      def initialize(client: HttpClient.build(base_url: BASE))
        @client = client
      end

      def forecast(lat:, lon:)
        resp = @client.get('/v1/forecast',
                           latitude: lat, longitude: lon, current: 'temperature_2m,wind_speed_10m')
        body = JSON.parse(resp.body)
        current = body.fetch('current')
        {
          temperature: current['temperature_2m'],
          wind_speed: current['wind_speed_10m'],
          observed_at: Time.zone.parse(current['time']),
          provider: 'open_meteo'
        }
      rescue Faraday::Error, JSON::ParserError, KeyError => e
        raise ProviderError, e.message
      end
    end
  end
end
