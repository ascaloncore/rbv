# frozen_string_literal: true

class StaticPagesController < ApplicationController
  before_action :require_login

  def top
    load_total_values
    load_status_breakdowns
    load_completed_count
  end

  private

  def load_total_values
    stocks = current_user.stocks
    @total_inventory_value = stocks.total_inventory_value
    @total_knowledge_asset_value = stocks.total_knowledge_asset_value
    @total_impairment_loss = stocks.total_impairment_loss
  end

  def load_status_breakdowns
    stocks = current_user.stocks
    @unread_value, @unread_count = status_value_and_count(stocks, :unread)
    @reading_value, @reading_count = status_value_and_count(stocks, :reading)
    @stagnant_value, @stagnant_count = status_value_and_count(stocks, :stagnant)
    @suspended_value, @suspended_count = status_value_and_count(stocks, :suspended)
    @impaired_value, @impaired_count = status_value_and_count(stocks, :impaired)
  end

  def load_completed_count
    @completed_count = current_user.stocks.where(status: :completed).count
  end

  def status_value_and_count(stocks, status)
    status_stocks = stocks.where(status: status)
    value = status_stocks.sum(:book_value) || 0
    count = status_stocks.count
    [value, count]
  end
end
