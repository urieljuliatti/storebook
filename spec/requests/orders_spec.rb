# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders API', type: :request do
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user: user, total_price: 50.0) }
  let(:author) { create(:author) }
  let(:book) { create(:book, price: 10.0, author_id: author.id) }
  let!(:cart_item) { create(:cart_item, cart: cart, book: book, quantity: 5) }
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /orders' do
    it 'returns a list of orders for the current user' do
      create(:order, user: user, total_price: 50.0, status: 'pendente')
      create(:order, user: user, total_price: 100.0, status: 'completed')

      get '/orders', params: { user_id: user.id }, headers: headers
      expect(response).to have_http_status(:success)

      orders = json
      expect(orders.size).to eq(2)
    end
  end

  describe 'GET /orders/:id' do
    let!(:order) { create(:order, user: user, total_price: 50.0, status: 'pendente') }

    it 'returns the specified order' do
      get "/orders/#{order.id}", headers: headers
      expect(response).to have_http_status(:success)

      order_response = json
      expect(order_response['id']).to eq(order.id)
      expect(order_response['total_price']).to eq('50.0')
      expect(order_response['status']).to eq(order.status)
    end
  end

  describe 'POST /orders' do
    it 'creates a new order and destroys the cart' do
      post '/orders', params: { cart_id: cart.id, user_id: user.id }, headers: headers
      expect(response).to have_http_status(:created)

      order = json
      expect(order['total_price']).to eq("50.0")
      expect(order['status']).to eq('pendente')

      expect(Cart.exists?(cart.id)).to be_falsey  # Verifica se o carrinho foi destruído
    end

    it 'does not create an order if the cart is not found' do
      post '/orders', params: { cart_id: 99999 }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  def json
    JSON.parse(response.body)
  end
end
