# frozen_string_literal: true

module Weather
  module Providers
    class OpenMeteo < Provider
      BASE = 'https://api.open-meteo.com'

      def initialize(client: HttpClient.build(base_url: BASE))
        super()

        @client = client
      end

      # Ежедневный прогноз на N дней
      def daily(lat:, lon:, days: 7)
        resp  = @client.get('/v1/forecast', params(lat:, lon:, days:))
        body  = JSON.parse(resp.body)
        daily = body.fetch('daily')

        days_arr = daily['time'].each_index.map do |i|
          {
            date: Date.parse(daily['time'][i]),
            t_min: daily['temperature_2m_min'][i],
            t_max: daily['temperature_2m_max'][i],
            wind_speed_max: daily['wind_speed_10m_max'][i]
          }
        end

        raise Weather::ProviderError, 'empty daily' if days_arr.empty?

        { type: 'daily', days: days_arr.first(days), provider: 'open_meteo' }
      rescue Faraday::Error, JSON::ParserError, KeyError, TypeError, ArgumentError => e
        raise Weather::ProviderError, e.message
      end

      private

      def params(lat:, lon:, days:)
        {
          latitude: lat,
          longitude: lon,
          daily: 'temperature_2m_max,temperature_2m_min,wind_speed_10m_max',
          forecast_days: days.to_i.clamp(1, 16),
          timezone: Time.zone.tzinfo.name
        }
      end
    end
  end
end
