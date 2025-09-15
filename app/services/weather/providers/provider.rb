# app/services/weather/providers/provider.rb
# frozen_string_literal: true

module Weather
  module Providers
    class Provider
      class UnsupportedType < Weather::ProviderError; end

      def fetch(lat:, lon:, type:)
        strategy = strategies.fetch(type) { raise UnsupportedType, "Unsupported type: #{type}" }
        raw = perform_request(path: strategy.path, params: strategy.params(lat:, lon:))
        strategy.normalize(raw)
      rescue Faraday::Error, JSON::ParserError, KeyError => e
        raise Weather::ProviderError, e.message
      end

      def capabilities
        strategies.keys
      end

      private

      def strategies
        raise NotImplementedError
      end

      def perform_request(path:, params:)
        resp = client.get(path, params)
        JSON.parse(resp.body)
      end

      def client
        raise NotImplementedError
      end
    end
  end
end
