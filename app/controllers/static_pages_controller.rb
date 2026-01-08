# frozen_string_literal: true

class StaticPagesController < ApplicationController
  before_action :require_login

  def top
    @total_inventory_value = current_user.stocks.total_inventory_value
    @total_knowledge_asset_value = current_user.stocks.total_knowledge_asset_value
    @total_impairment_loss = current_user.stocks.total_impairment_loss
  end
end
