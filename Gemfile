# frozen_string_literal: true

# Gemfile
source 'https://rubygems.org'
ruby '3.3.4'

# --- Core ---
gem 'circuitbox', '~> 2.0'
gem 'faraday', '~> 2.9'
gem 'faraday-retry'
gem 'geocoder'
gem 'haml-rails'
gem 'importmap-rails'
gem 'pg'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.2'
gem 'sprockets-rails'
gem 'view_component'
gem 'vite_rails'

# --- Auth ---
gem 'cancancan'
gem 'devise'

# --- Cache / Infra ---
gem 'connection_pool'
gem 'redis'

# --- HTTP / API ---
# TODO: remove
gem 'http', '~> 5.1'

# --- Perf/Boot ---
gem 'bootsnap', require: false
gem 'tzinfo-data', platforms: %i[windows jruby]

# --- Dev & Test ---
group :development, :test do
  gem 'active_storage_validations'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'vcr'
  gem 'webmock'

  gem 'brakeman', require: false
  gem 'rubocop', '~> 1.64', require: false
  gem 'rubocop-factory_bot', '~> 2.26', require: false
  gem 'rubocop-performance', '~> 1.21', require: false
  gem 'rubocop-rails', '~> 2.25', require: false
  gem 'rubocop-rspec', '~> 3.0', require: false
  gem 'rubocop-rspec_rails', '~> 2.30', require: false

  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
end

group :development do
  gem 'annotate', require: false
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner-active_record'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 6.5'
end
