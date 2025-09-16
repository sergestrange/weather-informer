# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Seeding users..."

admin = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.password = "password"
  u.password_confirmation = "password"
  u.role = :admin
end

viewer = User.find_or_create_by!(email: "viewer@example.com") do |u|
  u.password = "password"
  u.password_confirmation = "password"
  u.role = :viewer
end

puts "Seed complete:"
puts "Admin  -> email: #{admin.email}, password: password"
puts "Viewer -> email: #{viewer.email}, password: password"
