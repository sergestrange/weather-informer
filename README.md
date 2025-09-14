# Weather Informer (Rails 7.2)

Simple weather informer service with two roles (**admin** and **viewer**), user authentication, city management, and weather forecasts.

## Features

- Ruby 3.3.4 / Rails 7.2
- PostgreSQL database
- Devise authentication
- Role-based authorization via CanCanCan
    - **Admin**: can create/manage cities
    - **Viewer**: can view cities and check weather
- Weather API integration
- Redis caching for forecasts (15 minutes)
- RSpec test suite with FactoryBot, Shoulda
- Docker Compose support (web, db, redis)

## Setup

### Requirements

- Ruby 3.3.4
- PostgreSQL 16+
- Redis 7+
- Docker (optional)

### Installation

```bash
git clone https://github.com/sergestrange/weather-informer-rails.git
cd weather-informer-rails

bundle install
bin/rails db:setup
