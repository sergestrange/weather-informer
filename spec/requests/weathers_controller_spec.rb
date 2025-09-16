# frozen_string_literal: true

RSpec.describe WeathersController do
  let(:user) { create(:user) }
  let(:city_name) { 'City1' }
  let(:city) { create(:city, name: city_name) }

  before do
    Geocoder::Lookup::Test.add_stub(
      city_name,
      [{ 'latitude' => 55.7558, 'longitude' => 37.6173 }]
    )
    sign_in user
  end

  after { Geocoder::Lookup::Test.reset }

  describe 'GET /cities/:id/weather/daily' do
    context 'when service returns forecast' do
      it 'responds 200 and renders daily data' do
        weather_payload = {
          type: 'daily',
          days: [
            { date: Time.zone.today, t_min: 12.0, t_max: 19.0, wind_speed_max: 3.1, provider: 'stub' }
          ],
          provider: 'stub'
        }

        allow(Weather::FetchDaily)
          .to receive(:call).with(city: city, days: 7)
                            .and_return(weather_payload)

        get daily_city_weather_path(city, days: 7)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('19.0')
        expect(Weather::FetchDaily).to have_received(:call).with(city: city, days: 7)
      end
    end

    context 'when provider raises error' do
      it 'responds 200 and shows a friendly message' do
        allow(Weather::FetchDaily).to receive(:call).with(any_args)
                                                    .and_raise(Weather::ProviderError, 'unavailable')

        get daily_city_weather_path(city, days: 7)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(I18n.t('weather.service_unavailable'))
      end
    end
  end
end
