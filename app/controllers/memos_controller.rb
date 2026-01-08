# frozen_string_literal: true

class MemosController < ApplicationController
  before_action :require_login
  before_action :set_stock
  before_action :set_memo, only: [:destroy]

  def create
    @memo = current_user.memos.build(memo_params)
    @memo.stock = @stock

    if @memo.save
      redirect_to stock_path(@stock), success: I18n.t("controllers.memos.created")
    else
      redirect_to stock_path(@stock), danger: I18n.t("controllers.memos.create_failed")
    end
  end

  def destroy
    @memo.destroy
    redirect_to stock_path(@stock), success: I18n.t("controllers.memos.destroyed"), status: :see_other
  end

  private

  def set_stock
    @stock = Stock.find(params[:stock_id])
  end

  def set_memo
    @memo = current_user.memos.find(params[:id])
  end

  def memo_params
    params.require(:memo).permit(:body)
  end
end
