# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :set_order, only: [:show]

  def index
    @user = User.find(params[:user_id])
    @orders = Order.where(user: @user)
    render json: @orders
  end

  def show
    render json: @order
  end

  def create
    @cart = Cart.find(params[:cart_id])
    @user = User.find(params[:user_id])
    @order = Order.new(total_price: @cart.total_price, status: 'pendente', user: @user)

    if @order.save
      @cart.destroy
      render json: @order, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: e, status: :unprocessable_entity
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
