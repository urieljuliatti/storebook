# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { 'Frankenstein' }
    body  { 'This book is marvelous' }
    description { 'This is a description' }
    price { 20.00 }
    author
  end
end
