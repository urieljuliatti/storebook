FactoryBot.define do
  factory :book do
    title { "Frankenstein" }
    body  { "This book is marvelous" }
    description { "This is a description" }
    association :author
  end
end
