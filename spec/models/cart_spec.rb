# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'password') }
  let(:cart) { Cart.create!(user: user) }
  let(:author) { Author.create!(name: 'Uriel', bio: 'This is Uriel') }
  let(:book1) { Book.create!(title: 'Book 1', description: 'First book', price: 15.0, author_id: author.id) }
  let(:book2) { Book.create!(title: 'Book 2', description: 'Second book', price: 25.0, author_id: author.id) }

  before do
    cart.cart_items.create!(book: book1, quantity: 2)  # 2 * 15.0 = 30.0
    cart.cart_items.create!(book: book2, quantity: 1)  # 1 * 25.0 = 25.0
  end

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:cart_items).dependent(:destroy) }
  it { is_expected.to have_many(:books).through(:cart_items) }

  describe '#total_price' do
    it 'calculates the total price of all items in the cart' do
      expect(cart.total_price).to eq(55.0)  # 30.0 + 25.0 = 55.0
    end
  end
end
