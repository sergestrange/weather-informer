# frozen_string_literal: true

class WeathersController < ApplicationController
  before_action :authenticate_user!

  def show
    @city = City.find_by(id: params[:city_id])
    authorize! :weather, @city

    @current_weather = Weather::FetchCurrent.call(city: @city)
  rescue Weather::ProviderError => _e
    flash.now[:alert] = 'Weather service unavailable. Please try again later.'
    @current_weather = nil
  end
end
