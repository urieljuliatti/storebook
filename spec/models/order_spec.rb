# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'password') }
  let(:order) { Order.new(user: user, status: 'pending', total_price: 100.0) }

  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to validate_presence_of(:total_price) }

  it 'is valid with valid attributes' do
    expect(order).to be_valid
  end

  it 'is not valid without a status' do
    order.status = nil
    expect(order).to_not be_valid
  end

  it 'is not valid without a total_price' do
    order.total_price = nil
    expect(order).to_not be_valid
  end

  it 'is not valid without a user' do
    order.user = nil
    expect(order).to_not be_valid
  end
end
