# frozen_string_literal: true

module Weather
  module Config
    class << self
      def aggregator
        provider = Weather::Providers::OpenMeteo.new

        Weather::Aggregator.new(provider:)
      end

      delegate :cache, to: :Rails

      def ttl
        15.minutes
      end
    end
  end
end
