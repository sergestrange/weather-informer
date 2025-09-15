# frozen_string_literal: true

RSpec.describe Weather::FetchCurrent do
  let(:city)  { build_stubbed(:city, lat: 55.75, lon: 37.62) }
  let(:cache) { ActiveSupport::Cache::MemoryStore.new }
  let(:agg)   { instance_spy(Weather::Aggregator) }

  before do
    allow(Weather::Config).to receive_messages(cache: cache, aggregator: agg, ttl: 1.hour)
  end

  context 'when called two times' do
    before do
      2.times { described_class.call(city:) }
    end

    it 'caches result' do
      allow(agg).to receive(:forecast).and_return({ temp: 20 })

      expect(agg).to have_received(:forecast).once
      expect(agg).to have_received(:forecast).with(lat: city.lat, lon: city.lon)
    end
  end

  it 'bubbles ProviderError' do
    allow(agg).to receive(:forecast).and_raise(Weather::ProviderError, 'boom')

    expect { described_class.call(city:) }.to raise_error(Weather::ProviderError)
    expect(agg).to have_received(:forecast).once
  end
end
