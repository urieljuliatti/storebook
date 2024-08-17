
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author, type: :model do

  it 'is valid with a name' do
    author = Author.new(name: 'J.K. Rowling', bio: 'This is a bio')
    expect(author).to be_valid
  end

  it 'is invalid without a name' do
    author = Author.new(name: nil)
    expect(author).not_to be_valid
    expect(author.errors[:name]).to include("can't be blank")
  end

  it 'has many books' do
    association = Author.reflect_on_association(:books)
    expect(association.macro).to eq(:has_many)
  end
end
