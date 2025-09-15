# frozen_string_literal: true

module Weather
  module Config
    class << self
      def aggregator
        primary = Weather::Providers::OpenMeteo.new
        Weather::Aggregator.new(primary:)
      end

      delegate :cache, to: :Rails

      def ttl
        15.minutes
      end
    end
  end
end
