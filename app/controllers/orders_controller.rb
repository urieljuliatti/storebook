# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :set_order, only: [:show]

  def index
    @orders = Order.where(user: current_user)
    render json: @orders
  end

  def show
    render json: @order
  end

  def create
    @cart = Cart.find(params[:cart_id])
    @order = Order.new(total_price: @cart.total_price, status: 'pendente', user: current_user)

    if @order.save
      @cart.destroy
      render json: @order, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
