# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartItem, type: :model do

  let(:user) { User.create!(email: 'test@example.com', password: 'password') }
  let(:cart) { Cart.create!(user: user) }
  let(:author) { Author.create!(name: 'Uriel', bio: 'This is Uriel') }
  let(:book) { Book.create!(title: 'Sample Book', description: 'A sample book.', price: 10.0, author_id: author.id) }


  it { should belong_to(:cart) }
  it { should belong_to(:book) }


  it { should validate_numericality_of(:quantity).is_greater_than(0) }


  it 'is valid with valid attributes' do
    cart_item = CartItem.new(cart: cart, book: book, quantity: 1)
    expect(cart_item).to be_valid
  end

  it 'is not valid with a quantity less than or equal to 0' do
    cart_item = CartItem.new(cart: cart, book: book, quantity: 0)
    expect(cart_item).to_not be_valid
  end

  it 'is not valid without a cart' do
    cart_item = CartItem.new(cart: nil, book: book, quantity: 1)
    expect(cart_item).to_not be_valid
  end

  it 'is not valid without a book' do
    cart_item = CartItem.new(cart: cart, book: nil, quantity: 1)
    expect(cart_item).to_not be_valid
  end
end
