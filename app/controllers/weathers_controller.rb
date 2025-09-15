# frozen_string_literal: true

class WeathersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_city

  def current
    authorize! :weather, @city
    @weather = Weather::FetchCurrent.call(city: @city)
  rescue Weather::ProviderError
    flash.now[:alert] = 'Weather service unavailable. Please try again later.'
    @weather = nil
  end

  def daily
    authorize! :weather, @city
    @weather = Weather::FetchDaily7d.call(city: @city)
  rescue Weather::ProviderError
    flash.now[:alert] = 'Weather service unavailable. Please try again later.'
    @weather = nil
  end

  private

  def set_city
    @city = City.find(params[:city_id])
  end
end
