# frozen_string_literal: true

class AddBookValueAndImpairmentLossToStocks < ActiveRecord::Migration[8.1]
  def up
    # カラムを追加
    add_column :stocks, :book_value, :integer
    add_column :stocks, :impairment_loss, :integer

    # 既存データのマイグレーション
    # book_valueにpurchase_priceの値をコピー
    execute <<-SQL
      UPDATE stocks
      SET book_value = purchase_price
      WHERE book_value IS NULL
    SQL

    # impairment_lossを計算（purchase_price - book_value）
    # 初期状態ではbook_value = purchase_priceなので、impairment_loss = 0
    execute <<-SQL
      UPDATE stocks
      SET impairment_loss = COALESCE(purchase_price, 0) - COALESCE(book_value, 0)
      WHERE impairment_loss IS NULL
    SQL

    # デフォルト値を0に設定（新規レコード用）
    change_column_default :stocks, :book_value, 0
    change_column_default :stocks, :impairment_loss, 0
  end

  def down
    remove_column :stocks, :book_value
    remove_column :stocks, :impairment_loss
  end
end
