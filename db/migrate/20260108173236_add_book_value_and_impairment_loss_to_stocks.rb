# frozen_string_literal: true

class AddBookValueAndImpairmentLossToStocks < ActiveRecord::Migration[8.1]
  def up
    change_table :stocks, bulk: true do |t|
      t.integer :book_value
      t.integer :impairment_loss
    end

    # 既存データのマイグレーション
    # book_valueにpurchase_priceの値をコピー
    execute <<-SQL.squish
      UPDATE stocks
      SET book_value = purchase_price
      WHERE book_value IS NULL
    SQL

    # impairment_lossを計算（purchase_price - book_value）
    # 初期状態ではbook_value = purchase_priceなので、impairment_loss = 0
    execute <<-SQL.squish
      UPDATE stocks
      SET impairment_loss = COALESCE(purchase_price, 0) - COALESCE(book_value, 0)
      WHERE impairment_loss IS NULL
    SQL

    # デフォルト値を0に設定（新規レコード用）
    # rubocop:disable Rails/BulkChangeTable
    change_column_default :stocks, :book_value, 0
    change_column_default :stocks, :impairment_loss, 0
    # rubocop:enable Rails/BulkChangeTable
  end

  def down
    change_table :stocks, bulk: true do |t|
      t.remove :book_value
      t.remove :impairment_loss
    end
  end
end
