# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    user
    total_price { 100.0 }
    status { 'pendente' }
  end
end
