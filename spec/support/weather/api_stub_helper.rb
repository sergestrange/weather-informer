# frozen_string_literal: true

module ApiStubHelper
  def stub_open_meteo_daily(lat:, lon:, days:, fixture: 'open_meteo/daily.json')
    url = 'https://api.open-meteo.com/v1/forecast'
    body = Rails.root.join('spec/fixtures', fixture).read

    stub_request(:get, url)
      .with(query: hash_including(
        'latitude' => lat.to_s,
        'longitude' => lon.to_s,
        'daily' => 'temperature_2m_max,temperature_2m_min,wind_speed_10m_max',
        'forecast_days' => days.to_s
      ))
      .to_return(status: 200, body: body, headers: { 'Content-Type' => 'application/json' })
  end
end

RSpec.configure do |config|
  config.include ApiStubHelper
end
