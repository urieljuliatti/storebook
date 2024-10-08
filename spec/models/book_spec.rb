# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do

  it 'is valid with a title, description, price and an author' do
    author = Author.create!(name: 'J.K. Rowling')
    book = Book.new(title: 'Harry Potter', description: 'This is the description', price: 20.00, author: author)
    expect(book).to be_valid
  end

  it 'is invalid without a title' do
    author = Author.create!(name: 'J.K. Rowling')
    book = Book.new(title: nil, author: author)
    expect(book).not_to be_valid
    expect(book.errors[:title]).to include("can't be blank")
  end

  it 'is invalid without an author' do
    book = Book.new(title: 'Harry Potter')
    expect(book).not_to be_valid
    expect(book.errors[:author]).to include("must exist")
  end

  it 'belongs to an author' do
    association = Book.reflect_on_association(:author)
    expect(association.macro).to eq(:belongs_to)
  end
end
