# frozen_string_literal: true

class StaticPagesController < ApplicationController
  before_action :require_login

  def top
    @total_inventory_value = current_user.stocks.total_inventory_value
    @total_knowledge_asset_value = current_user.stocks.total_knowledge_asset_value
    @total_impairment_loss = current_user.stocks.total_impairment_loss

    # 適正在庫内訳
    @unread_value = current_user.stocks.where(status: :unread).sum(:book_value) || 0
    @unread_count = current_user.stocks.where(status: :unread).count
    @reading_value = current_user.stocks.where(status: :reading).sum(:book_value) || 0
    @reading_count = current_user.stocks.where(status: :reading).count

    # 滞留在庫内訳
    @stagnant_value = current_user.stocks.where(status: :stagnant).sum(:book_value) || 0
    @stagnant_count = current_user.stocks.where(status: :stagnant).count

    # 不良在庫内訳
    @suspended_value = current_user.stocks.where(status: :suspended).sum(:book_value) || 0
    @suspended_count = current_user.stocks.where(status: :suspended).count

    # 減損損失内訳
    @impaired_value = current_user.stocks.where(status: :impaired).sum(:book_value) || 0
    @impaired_count = current_user.stocks.where(status: :impaired).count

    # 知識資産の詳細
    @completed_count = current_user.stocks.where(status: :completed).count
  end
end
