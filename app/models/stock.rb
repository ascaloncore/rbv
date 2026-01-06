# frozen_string_literal: true

class Stock < ApplicationRecord
  belongs_to :user
  belongs_to :category

  enum :status, {
    unstarted: 0,    # 未着手
    in_progress: 1,  # 学習中
    completed: 2     # 完了
  }

  validates :title, presence: true, length: { maximum: 255 }
  validates :purchase_price, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :status, presence: true
end
