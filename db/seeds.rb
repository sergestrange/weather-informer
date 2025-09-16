# frozen_string_literal: true

logger = Rails.logger || ActiveSupport::Logger.new($stdout)

logger.info 'Seeding users…'

User.find_or_create_by!(email: 'admin@example.com') do |u|
  u.password = 'password123'
  u.role = 'admin'
end

User.find_or_create_by!(email: 'user@example.com') do |u|
  u.password = 'password123'
  u.role = 'viewer'
end

logger.info 'Seeding cities…'

City.find_or_create_by!(name: 'Moscow', lat: 55.7558, lon: 37.6173)
City.find_or_create_by!(name: 'Amsterdam', lat: 52.3676, lon: 4.9041)

logger.info 'Seeding done.'
