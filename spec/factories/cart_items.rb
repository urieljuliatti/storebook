FactoryBot.define do
  factory :cart_item do
    cart
    book
    quantity { 1 }
  end
end
