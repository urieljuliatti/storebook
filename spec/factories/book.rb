FactoryBot.define do
  factory :book do
    title { "Frankenstein" }
    body  { "This book is marvelous" }
    association :author
  end
end
