# frozen_string_literal: true

FactoryBot.define do
  factory :cart_item do
    cart
    book
    quantity { 1 }
  end
end
