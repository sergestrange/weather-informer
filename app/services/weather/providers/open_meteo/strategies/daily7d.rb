# frozen_string_literal: true

module Weather
  module Providers
    class OpenMeteo < Provider
      module Strategies
        class Daily7d < Base
          def params(lat:, lon:)
            {
              latitude: lat,
              longitude: lon,
              daily: 'temperature_2m_max,temperature_2m_min,wind_speed_10m_max',
              forecast_days: 7
            }
          end

          def normalize(body)
            daily = body.fetch('daily')
            days = daily['time'].each_index.map do |i|
              {
                date: Date.parse(daily['time'][i]),
                t_min: daily['temperature_2m_min'][i],
                t_max: daily['temperature_2m_max'][i],
                wind_speed_max: daily['wind_speed_10m_max'][i]
              }
            end
            { type: 'daily_7d', days:, provider: 'open_meteo' }
          end
        end
      end
    end
  end
end
