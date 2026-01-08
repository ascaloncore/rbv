# frozen_string_literal: true

class Stock < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :memos, dependent: :destroy

  enum :status, {
    unread: 0,       # 未読 (適正在庫)
    reading: 10,     # 読書中 (適正在庫)
    stagnant: 20,    # 停滞中 (滞留在庫)
    suspended: 30,   # 中断中 (不良在庫)
    impaired: 40,    # 減損損失 (読書撤退損)
    completed: 50    # 読書完了 (知識資産)
  }

  validates :title, presence: true, length: { maximum: 255 }
  validates :purchase_price, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :status, presence: true

  # コールバック: 新規作成時または購入金額変更時にbook_valueとimpairment_lossを自動設定
  before_validation :set_book_value_and_impairment_loss, if: :should_update_book_value?

  # スコープ: 完了以外の在庫
  scope :not_completed, -> { where.not(status: :completed) }

  # 集計メソッド（クラスメソッド）
  class << self
    # 在庫金額総額（完了以外のbook_valueの合計）
    def total_inventory_value
      not_completed.sum(:book_value) || 0
    end

    # 知識資産総額（完了のbook_valueの合計）
    def total_knowledge_asset_value
      where(status: :completed).sum(:book_value) || 0
    end

    # 減損損失累計額（完了以外のimpairment_lossの合計）
    def total_impairment_loss
      not_completed.sum(:impairment_loss) || 0
    end
  end

  private

  def should_update_book_value?
    # 新規作成時、または購入金額が変更された場合
    new_record? || purchase_price_changed?
  end

  def set_book_value_and_impairment_loss
    return unless purchase_price
    return unless attributes_exist?

    update_book_value
    calculate_impairment_loss
  end

  def attributes_exist?
    has_attribute?(:book_value) && has_attribute?(:impairment_loss)
  end

  def update_book_value
    if new_record?
      self.book_value = purchase_price if book_value.nil? || book_value.zero?
    elsif purchase_price_changed?
      self.book_value = purchase_price
    end
  end

  def calculate_impairment_loss
    self.impairment_loss = purchase_price - book_value
    self.impairment_loss = [impairment_loss, 0].max
  end
end
