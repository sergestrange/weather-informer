# frozen_string_literal: true

class City < ApplicationRecord
  geocoded_by :name, latitude: :lat, longitude: :lon

  before_validation :geocode, if: :will_save_change_to_name?

  validates :name, presence: true, length: { maximum: 100 }
  validates :lat, presence: true,
                  numericality: { greater_than_or_equal_to: -90,
                                  less_than_or_equal_to: 90 }

  validates :lon, presence: true,
                  numericality: { greater_than_or_equal_to: -180,
                                  less_than_or_equal_to: 180 }

  validate :geocoding_must_succeed, if: :will_save_change_to_name?

  private

  def geocoding_must_succeed
    return unless lat.blank? || lon.blank?

    errors.add(:name, I18n.t('errors.messages.not_found_on_map'))
  end
end
