# frozen_string_literal: true

RSpec.describe WeathersController do
  let(:user) { create(:user) }
  let(:city) { create(:city) }

  before { sign_in user }

  it 'returns 200 with weather data' do
    ok = { temperature: 19.0, wind_speed: 3.1, observed_at: Time.zone.now, provider: 'stub' }
    allow_any_instance_of(Weather::Aggregator)
      .to receive(:forecast).and_return(ok)

    get city_weather_path(city)
    expect(response).to have_http_status(:ok)
    expect(response.body).to include('19.0')
  end

  it 'shows friendly message on provider error' do
    allow_any_instance_of(Weather::Aggregator)
      .to receive(:forecast).and_raise(Weather::ProviderError, 'unavailable')

    get city_weather_path(city)
    expect(response).to have_http_status(:ok)
    expect(response.body).to include('Weather service unavailable')
  end
end
