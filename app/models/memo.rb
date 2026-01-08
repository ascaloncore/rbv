# frozen_string_literal: true

class Memo < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  validates :body, presence: true, length: { maximum: 400 }
end
