# frozen_string_literal: true

module Weather
  class BaseOperation
    class << self
      def call(**)
        new(**).call
      end
    end

    private

    def cache
      Weather::Config.cache
    end

    def ttl
      Weather::Config.ttl
    end

    def aggregator
      Weather::Config.aggregator
    end

    def cache_key(parts)
      parts.join(':')
    end
  end
end
