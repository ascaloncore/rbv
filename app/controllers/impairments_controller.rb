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

    if stock_ids.empty?
      redirect_to impairments_path, danger: I18n.t("controllers.impairments.no_selection")
      return
    end

    # 選択された在庫を取得（自分の在庫のみ）
    stocks = current_user.stocks.not_completed.where(id: stock_ids)

    if stocks.empty?
      redirect_to impairments_path, danger: I18n.t("controllers.impairments.invalid_selection")
      return
    end

    # 減損処理を実行
    processed_count = 0
    ActiveRecord::Base.transaction do
      stocks.each do |stock|
        # ステータスを「減損損失(impaired: 40)」に変更
        stock.status = :impaired

        # book_valueを1円に設定
        stock.book_value = 1

        # impairment_lossを再計算（purchase_price - book_value）
        stock.impairment_loss = (stock.purchase_price || 0) - stock.book_value
        # 0円以上に制限
        stock.impairment_loss = [stock.impairment_loss, 0].max

        stock.save!
        processed_count += 1
      end
    end

    redirect_to root_path, success: I18n.t("controllers.impairments.processed", count: processed_count)
  rescue StandardError
    redirect_to impairments_path, danger: I18n.t("controllers.impairments.process_failed")
  end
end
