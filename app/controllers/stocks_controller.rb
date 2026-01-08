# frozen_string_literal: true

class StocksController < ApplicationController
  before_action :require_login
  before_action :set_stock, only: %i[show edit update destroy]

  def index
    @stocks = current_user.stocks.includes(:category).order(
      Arel.sql('purchase_date DESC NULLS LAST, created_at DESC')
    )
  end

  def show
    # @stock is set by set_stock before_action
    # N+1クエリを防ぐためにuserをincludes
    @stock.memos.includes(:user)
  end

  def new
    @stock = current_user.stocks.build
    @categories = Category.all
  end

  def edit
    @categories = Category.all
  end

  def create
    @stock = current_user.stocks.build(stock_params)
    @categories = Category.all
    if @stock.save
      redirect_to stocks_path, success: I18n.t("controllers.stocks.created")
    else
      flash.now[:danger] = I18n.t("controllers.stocks.create_failed")
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @stock.update(stock_params)
      redirect_to stock_path(@stock), success: I18n.t("controllers.stocks.updated")
    else
      @categories = Category.all
      flash.now[:danger] = I18n.t("controllers.stocks.update_failed")
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @stock.destroy
    redirect_to stocks_path, success: I18n.t("controllers.stocks.destroyed"), status: :see_other
  end

  private

  def set_stock
    @stock = current_user.stocks.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:title, :purchase_price, :purchase_date, :status, :impression, :category_id)
  end
end
