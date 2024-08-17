# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/v1/books', type: :request do
  let!(:author) { create(:author, name: 'John Doe') }

  let!(:book) { Book.create!(valid_attributes) }

  let(:valid_attributes) {
    { 'title' => 'foo', 'body' => 'foo', 'description' => 'this is a description', 'price' => '20', 'author_id' => author.id }
  }

  let(:invalid_attributes) {
    {'title' => '', 'body' => 'foo'}
  }

  let(:user_params) {
    {:email => 'admin@email.com', :password => '123456'}
  }

  let(:token) do
    user = create(:user, **user_params)
    post '/login', params: { email: user.email, password: user.password }, as: :json
    JSON.parse(response.body)['token']
  end

  let(:valid_headers) {
    { 'Authorization' => "Bearer #{token}" }
  }

  describe 'GET /index' do
    it 'renders a successful response' do
      Book.create! valid_attributes
      get api_v1_books_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get api_v1_book_url(book), headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Book' do
        expect {
          post api_v1_books_url,
               params: { book: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Book, :count).by(1)
      end

      it 'renders a JSON response with the new book' do
        post api_v1_books_url,
             params: { book: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Book' do
        expect {
          post api_v1_books_url,
               params: { book: invalid_attributes }, headers: valid_headers, as: :json
        }.to change(Book, :count).by(0)
      end

      it 'renders a JSON response with errors for the new book' do
        post api_v1_books_url,
             params: { book: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) { { 'title' => 'foo 2', 'body' => 'foo' } }

      it 'updates the requested book' do
        patch api_v1_book_url(book),
              params: { book: new_attributes }, headers: valid_headers, as: :json
        book.reload
        expect(response).to have_http_status(:ok)
      end

      it 'renders a JSON response with the book' do
        patch api_v1_book_url(book),
              params: { book: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the book' do
        patch api_v1_book_url(book),
              params: { book: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested book' do
      expect {
        delete api_v1_book_url(book), headers: valid_headers, as: :json
      }.to change(Book, :count).by(-1)
    end

    it 'returns a 404 status if the book does not exist' do
      expect {
        delete api_v1_book_url(id: 'non-existent-id'), headers: valid_headers, as: :json
      }.not_to change(Book, :count)
      expect(response).to have_http_status(:not_found)
    end

    it 'returns a successful response' do
      delete api_v1_book_url(book), headers: valid_headers, as: :json
      expect(response).to have_http_status(:no_content)
    end
  end
end
