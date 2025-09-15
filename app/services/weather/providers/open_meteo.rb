# frozen_string_literal: true

module Weather
  module Providers
    class OpenMeteo < Provider
      BASE = 'https://api.open-meteo.com'

      def initialize(client: HttpClient.build(base_url: BASE))
        super()
        @client = client
      end

      def fetch(type:, lat:, lon:)
        strategy = strategies.fetch(type) { raise Provider::UnsupportedType, "Unsupported type: #{type}" }
        raw = perform_request(path: strategy.path, params: strategy.params(lat:, lon:))
        strategy.normalize(raw)
      rescue Faraday::Error, JSON::ParserError, KeyError => e
        raise Weather::ProviderError, e.message
      end

      def capabilities = strategies.keys

      private

      attr_reader :client

      def perform_request(path:, params:)
        resp = client.get(path, params)
        JSON.parse(resp.body)
      end

      def strategies
        @strategies ||= {
          current: OpenMeteo::Strategies::Current.new,
          daily_7d: OpenMeteo::Strategies::Daily7d.new
        }
      end
    end
  end
end
