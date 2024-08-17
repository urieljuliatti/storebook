FactoryBot.define do
  factory :book do
    title { "Frankenstein" }
    body  { "This book is marvelous" }
    description { "This is a description" }
    price { 20.00 }
    author
    title { "How to read a book effectively" }
    body { "There are five steps involved." }
  end
end
