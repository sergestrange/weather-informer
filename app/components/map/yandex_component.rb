# frozen_string_literal: true

module Map
  class YandexComponent < ViewComponent::Base
    def initialize(lat:, lon:, zoom: 13, height: '400px', api_key: nil)
      super
      @lat       = lat.to_f
      @lon       = lon.to_f
      @zoom      = zoom.to_i
      @height    = height
      # TODO: remove
      @api_key   = '8f56a99a-9414-40e5-8b3c-e1f6cf255297'
    end

    private

    attr_reader :lat, :lon, :zoom, :height, :api_key
  end
end
