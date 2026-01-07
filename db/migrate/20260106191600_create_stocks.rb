# frozen_string_literal: true

class CreateStocks < ActiveRecord::Migration[8.1]
  def change
    create_table :stocks do |t|
      t.string :title, null: false
      t.integer :purchase_price
      t.date :acquired_on
      t.integer :status, default: 0, null: false
      t.text :impression
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
