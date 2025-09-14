# frozen_string_literal: true

class AddRoleToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :role, :string, null: false, default: 'viewer'
    add_index  :users, :role

    add_check_constraint :users, "role IN ('viewer','admin')", name: 'users_role_allowed'
  end
end
