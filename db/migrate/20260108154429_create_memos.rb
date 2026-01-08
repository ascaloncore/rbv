# frozen_string_literal: true

class CreateMemos < ActiveRecord::Migration[8.1]
  def change
    create_table :memos do |t|
      t.text :body
      t.references :user, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true

      t.timestamps
    end
  end
end
