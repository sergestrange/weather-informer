# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { viewer: 'viewer', admin: 'admin' }, default: 'viewer', validate: true
end
