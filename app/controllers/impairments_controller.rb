# frozen_string_literal: true

class ImpairmentsController < ApplicationController
  before_action :require_login

  def index
    # ステータスが「完了」以外の在庫を表示対象とする
    @stocks = current_user.stocks.includes(:category).not_completed.order(
      Arel.sql('purchase_date DESC NULLS LAST, created_at DESC')
    )
  end

  def create
    stock_ids = params[:stock_ids] || []
    return redirect_with_error(:no_selection) if stock_ids.empty?

    stocks = find_target_stocks(stock_ids)
    return redirect_with_error(:invalid_selection) if stocks.empty?

    processed_count = process_impairments(stocks)
    redirect_to root_path, success: I18n.t("controllers.impairments.processed", count: processed_count)
  rescue StandardError
    redirect_to impairments_path, danger: I18n.t("controllers.impairments.process_failed")
  end

  private

  def find_target_stocks(stock_ids)
    current_user.stocks.not_completed.where(id: stock_ids)
  end

  def process_impairments(stocks)
    processed_count = 0
    ActiveRecord::Base.transaction do
      stocks.each do |stock|
        apply_impairment(stock)
        stock.save!
        processed_count += 1
      end
    end
    processed_count
  end

  def apply_impairment(stock)
    stock.status = :impaired
    stock.book_value = 1
    stock.impairment_loss = calculate_impairment_loss(stock.purchase_price, stock.book_value)
  end

  def calculate_impairment_loss(purchase_price, book_value)
    [(purchase_price || 0) - book_value, 0].max
  end

  def redirect_with_error(error_key)
    redirect_to impairments_path, danger: I18n.t("controllers.impairments.#{error_key}")
  end
end
