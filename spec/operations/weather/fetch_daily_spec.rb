# frozen_string_literal: true

RSpec.describe Weather::FetchDaily do
  include ActiveSupport::Testing::TimeHelpers

  let(:city) do
    instance_double(
      City,
      lat: 55.7558,
      lon: 37.6173,
      cache_key_with_version: 'cities/1-2025-09-16'
    )
  end

  let(:payload7) do
    {
      type: 'daily',
      days: [{ date: Time.zone.today, t_min: 10.0, t_max: 18.0, wind_speed_max: 5.0 }],
      provider: 'open_meteo'
    }
  end

  let(:payload3) do
    {
      type: 'daily',
      days: [{ date: Time.zone.today, t_min: 11.0, t_max: 19.0, wind_speed_max: 4.0 }],
      provider: 'open_meteo'
    }
  end

  let(:cache_store) { ActiveSupport::Cache::MemoryStore.new }
  let(:agg)         { instance_spy(Weather::Aggregator) }

  before do
    allow_any_instance_of(described_class).to receive(:cache).and_return(cache_store)
    allow_any_instance_of(described_class).to receive(:ttl).and_return(45.minutes)
    allow_any_instance_of(described_class).to receive(:aggregator).and_return(agg)
  end

  describe '#call' do
    context 'when cache is empty' do
      it 'calls the aggregator and stores result in cache' do
        allow(agg).to receive(:daily)
          .with(lat: 55.7558, lon: 37.6173, days: 7)
          .and_return(payload7)

        result = described_class.new(city: city, days: 7).call

        expect(result).to eq(payload7)
        expect(agg).to have_received(:daily)
          .with(lat: 55.7558, lon: 37.6173, days: 7)
          .once
      end
    end

    context 'when value is already cached' do
      it 'returns cached value without calling aggregator again' do
        # warm up cache
        allow(agg).to receive(:daily)
          .with(lat: 55.7558, lon: 37.6173, days: 7)
          .and_return(payload7)

        described_class.new(city: city, days: 7).call
        expect(agg).to have_received(:daily).once

        # second call should hit cache (no extra aggregator calls)
        result = described_class.new(city: city, days: 7).call

        expect(result).to eq(payload7)
        expect(agg).to have_received(:daily).once
      end
    end

    context 'when days parameter changes' do
      it 'uses different cache keys for different days values' do
        allow(agg).to receive(:daily)
          .with(lat: 55.7558, lon: 37.6173, days: 7)
          .and_return(payload7)
        allow(agg).to receive(:daily)
          .with(lat: 55.7558, lon: 37.6173, days: 3)
          .and_return(payload3)

        res7 = described_class.new(city: city, days: 7).call
        res3 = described_class.new(city: city, days: 3).call

        expect(res7).to eq(payload7)
        expect(res3).to eq(payload3)
        expect(agg).to have_received(:daily).with(lat: 55.7558, lon: 37.6173, days: 7).once
        expect(agg).to have_received(:daily).with(lat: 55.7558, lon: 37.6173, days: 3).once
      end
    end

    context 'when TTL expires' do
      it 'calls aggregator again after TTL has passed' do
        allow_any_instance_of(described_class).to receive(:ttl).and_return(1.minute)
        allow(agg).to receive(:daily)
          .with(lat: 55.7558, lon: 37.6173, days: 7)
          .and_return(payload7)

        # first call -> populates cache
        described_class.new(city: city, days: 7).call
        expect(agg).to have_received(:daily).once

        # still cached
        travel 30.seconds
        expect(described_class.new(city: city, days: 7).call).to eq(payload7)
        expect(agg).to have_received(:daily).once

        # after TTL -> aggregator called again
        travel 61.seconds
        described_class.new(city: city, days: 7).call
        expect(agg).to have_received(:daily).twice
      ensure
        travel_back
      end
    end
  end
end
