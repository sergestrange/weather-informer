# frozen_string_literal: true

module Weather
  module Providers
    class OpenMeteo < Provider
      module Strategies
        PATH = '/v1/forecast'
        class Base
          def path = PATH
        end
      end
    end
  end
end
