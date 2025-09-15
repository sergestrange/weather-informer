# frozen_string_literal: true

# app/controllers/cities_controller.rb
class CitiesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index; end
  def new; end

  def create
    if @city.update(city_params)
      redirect_to cities_path, notice: t('cities.flash.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def city_params
    params.require(:city).permit(:name)
  end
end
