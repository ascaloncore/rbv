# frozen_string_literal: true

class StocksController < ApplicationController
  before_action :require_login
  before_action :set_stock, only: %i[edit update destroy]

  def index
    @stocks = current_user.stocks.includes(:category).order(created_at: :desc)
  end

  def new
    @stock = current_user.stocks.build
    @categories = Category.all
  end

  def create
    @stock = current_user.stocks.build(stock_params)
    @categories = Category.all
    if @stock.save
      redirect_to stocks_path, success: "在庫を登録しました。"
    else
      flash.now[:danger] = "登録に失敗しました。入力内容を確認してください。"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    if @stock.update(stock_params)
      redirect_to stocks_path, success: "在庫を更新しました。"
    else
      @categories = Category.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @stock.destroy
    redirect_to stocks_path, notice: "在庫を削除しました。", status: :see_other
  end

  private

  def set_stock
    @stock = current_user.stocks.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:title, :purchase_price, :purchase_date, :status, :impression, :category_id)
  end
end
