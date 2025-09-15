# frozen_string_literal: true

module Weather
  module Providers
    class OpenMeteo < Provider
      module Strategies
        class Current < Base
          def params(lat:, lon:)
            { latitude: lat, longitude: lon, current: 'temperature_2m,wind_speed_10m' }
          end

          def normalize(body)
            current = body.fetch('current')
            {
              type: 'current',
              temperature: current['temperature_2m'],
              wind_speed: current['wind_speed_10m'],
              observed_at: Time.zone.parse(current['time']),
              provider: 'open_meteo'
            }
          end
        end
      end
    end
  end
end
