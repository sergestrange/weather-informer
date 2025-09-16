# frozen_string_literal: true

module Weather
  module Providers
    class Provider
      class << self
        def key = name.demodulize.underscore
      end

      def daily(lat:, lon:, days: 7)
        raise NotImplementedError
      end
    end
  end
end
