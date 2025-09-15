# frozen_string_literal: true

FactoryBot.define do
  factory :city do
    sequence(:name) { |n| "City#{n}" }
    lat { 52.3676 }
    lon { 4.9041 }
  end
end
