# frozen_string_literal: true

RSpec.describe Weather::Providers::OpenMeteo do
  let(:provider) { described_class.new }

  around do |example|
    Time.use_zone('Europe/Amsterdam') { example.run }
  end

  def build_body(days_count: 3, start_date: Date.new(2025, 9, 16))
    dates = Array.new(days_count) { |i| (start_date + i).iso8601 }
    {
      'daily' => {
        'time' => dates,
        'temperature_2m_min' => Array.new(days_count) { 10.0 },
        'temperature_2m_max' => Array.new(days_count) { 20.0 },
        'wind_speed_10m_max' => Array.new(days_count) { 5.0 }
      }
    }.to_json
  end

  describe '#daily' do
    context 'when API returns valid response' do
      it 'parses forecast into normalized hash' do
        response = instance_double(Faraday::Response, body: build_body(days_count: 3))
        client   = instance_double(Faraday::Connection, get: response)

        provider = described_class.new(client:)
        result   = provider.daily(lat: 55.7558, lon: 37.6173, days: 3)

        expect(result[:type]).to eq('daily')
        expect(result[:provider]).to eq('open_meteo')
        expect(result[:days].size).to eq(3)
      end
    end

    context 'when API returns empty daily array' do
      it 'raises Weather::ProviderError' do
        empty_body = {
          'daily' => {
            'time' => [],
            'temperature_2m_min' => [],
            'temperature_2m_max' => [],
            'wind_speed_10m_max' => []
          }
        }.to_json

        response = instance_double(Faraday::Response, body: empty_body)
        client   = instance_double(Faraday::Connection, get: response)

        provider = described_class.new(client:)
        expect do
          provider.daily(lat: 1.0, lon: 2.0, days: 7)
        end.to raise_error(Weather::ProviderError, 'empty daily')
      end
    end
  end
end
