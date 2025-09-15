# frozen_string_literal: true

class WeathersController < ApplicationController
  before_action :authenticate_user!

  def show
    @city = City.find(params[:city_id])
    authorize! :weather, @city

    @weather = Rails.cache.fetch("weather:#{@city.id}", expires_in: 15.minutes) do
      aggregator.forecast(lat: @city.lat, lon: @city.lon)
    end
  rescue Weather::ProviderError => e
    flash.now[:alert] = 'Weather service unavailable. Please try again later.'
    Rails.logger.warn("[weather] #{e.class}: #{e.message}")
    @weather = nil
  end

  private

  def aggregator
    primary = Weather::Providers::OpenMeteo.new
    Weather::Aggregator.new(primary:, name: 'weather_primary')
  end
end
