# frozen_string_literal: true

class WeathersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_city

  def daily
    authorize! :weather, @city
    @weather = Weather::FetchDaily.call(city: @city, days: 7)
  rescue Weather::ProviderError
    flash.now[:alert] = I18n.t('weather.service_unavailable')
    @weather = nil
  end

  private

  def set_city
    @city = City.find(params[:city_id])
  end
end
