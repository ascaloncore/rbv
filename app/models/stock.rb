# frozen_string_literal: true

class Stock < ApplicationRecord
  belongs_to :user
  belongs_to :category

  enum :status, {
    unread: 0,       # 未読 (適正在庫)
    reading: 1,      # 読書中 (適正在庫)
    stagnant: 2,     # 停滞中 (滞留在庫)
    suspended: 3,    # 中断中 (不良在庫)
    impaired: 4,     # 減損損失 (読書撤退損)
    completed: 5     # 読書完了 (知識資産)
  }

  validates :title, presence: true, length: { maximum: 255 }
  validates :purchase_price, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :status, presence: true
  validates :category_id, presence: true
end
