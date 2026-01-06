# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :stocks, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
end
