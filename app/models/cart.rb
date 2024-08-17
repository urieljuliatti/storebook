# frozen_string_literal: true

class Cart < ApplicationRecord
  belongs_to :user

  has_many :cart_items, dependent: :destroy
  has_many :books, through: :cart_items

  def total_price
    cart_items.includes(:book).sum { |ci| ci.book.price * ci.quantity }
  end
end
