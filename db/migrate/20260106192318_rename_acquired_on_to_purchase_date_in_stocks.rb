# frozen_string_literal: true

class RenameAcquiredOnToPurchaseDateInStocks < ActiveRecord::Migration[8.1]
  def change
    rename_column :stocks, :acquired_on, :purchase_date
  end
end
