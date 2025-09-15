# frozen_string_literal: true

class CreateCities < ActiveRecord::Migration[7.2]
  def change
    create_table :cities do |t|
      t.string :name
      t.decimal :lat, precision: 9, scale: 6
      t.decimal :lon, precision: 9, scale: 6

      t.timestamps
    end
  end
end
