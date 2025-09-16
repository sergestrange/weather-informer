# frozen_string_literal: true

module Weather
  class Provider
    def forecast(lat:, lon:, type:)
      raise NotImplementedError
    end
  end
end
