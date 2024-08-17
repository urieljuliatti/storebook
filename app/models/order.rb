# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  validates :status, :total_price, presence: true
end
