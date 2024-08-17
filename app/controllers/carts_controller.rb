# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :add_item, :remove_item]

  # Exibe o carrinho atual do usuário
  def show
    render json: @cart, include: [:books]
  end

  # Cria um novo carrinho para o usuário (opcional, caso não exista um)
  def create
    @cart = current_user.carts.create(total_price: 0)
    render json: @cart, status: :created
  end

  # Adiciona um item ao carrinho
  def add_item
    book = Book.find(params[:book_id])
    cart_item = @cart.cart_items.find_or_initialize_by(book: book)
    cart_item.quantity = 0
    cart_item.quantity += 1
    cart_item.save
    update_total_price

    render json: @cart, include: [:books], status: :ok
  end

  # Remove um item do carrinho
  def remove_item
    book = Book.find(params[:book_id])
    cart_item = @cart.cart_items.find_by(book: book)

    if cart_item
      cart_item.quantity -= 1
      cart_item.save
      cart_item.destroy if cart_item.quantity <= 0
      update_total_price
    end

    render json: @cart, include: [:books], status: :ok
  end

  private

  def set_cart
    @cart = current_user.carts.find(params[:id])
  end

  def update_total_price
    @cart.update(total_price: @cart.total_price)
  end
end
