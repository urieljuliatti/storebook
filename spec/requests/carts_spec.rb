# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Carts API', type: :request do
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user: user) }
  let(:book) { create(:book) }
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /carts/:id' do
    it 'returns the cart with associated books' do
      create(:cart_item, cart: cart, book: book, quantity: 1)

      get "/carts/#{cart.id}", params: { user_id: user.id }, headers: headers
      expect(response).to have_http_status(:success)
      expect(json['total_price']).to eq('20.0')
      expect(json['books']).not_to be_empty
    end
  end

  describe 'POST /carts' do
    it 'creates a new cart for the user' do
      expect {
        post '/carts', params: { cart: { total_price: 0.0 }, user_id: user.id }, headers: headers
      }.to change { Cart.count }.by(1)
      expect(response).to have_http_status(:created)
    end
  end

  describe 'POST /carts/:id/add_item' do
    it 'adds an item to the cart' do
      post "/carts/#{cart.id}/add_item", params: { book_id: book.id, user_id: user.id }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(cart.cart_items.count).to eq(1)
      expect(cart.cart_items.first.quantity).to eq(1)
    end
  end

  describe 'POST /carts/:id/remove_item' do
    it 'removes an item from the cart' do
      create(:cart_item, cart: cart, book: book, quantity: 1)
      post "/carts/#{cart.id}/remove_item", params: { book_id: book.id, user_id: user.id }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(cart.cart_items.count).to eq(0)
    end
  end

  def json
    JSON.parse(response.body)
  end
end
