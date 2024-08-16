require 'rails_helper'

RSpec.describe '/api/v1/books', type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Book. As you add validations to Book, be sure to
  # adjust the attributes here as well.

  let!(:author) { create(:author, name: 'John Doe') }

  let(:valid_attributes) {
    {'title'=>'foo', 'body'=>'foo', 'author_id' => author.id }
  }

  let(:invalid_attributes) {
    {'title'=>'', 'body'=>'foo'}
  }

  let(:user_params) {
    {:email => "admin@email.com", :password => "123456"}
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
      book = Book.create! valid_attributes
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
      let(:new_attributes) {
        {'title'=>'foo 2', 'body'=>'foo'}
      }

      it 'updates the requested book' do
        book = Book.create! valid_attributes
        patch api_v1_book_url(book),
              params: { book: new_attributes }, headers: valid_headers, as: :json
        book.reload
        expect(response).to have_http_status(:ok)
      end

      it 'renders a JSON response with the book' do
        book = Book.create! valid_attributes
        patch api_v1_book_url(book),
              params: { book: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the book' do
        book = Book.create! valid_attributes

        patch api_v1_book_url(book),
              params: { book: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested book' do
      book = Book.create! valid_attributes
      expect {
        delete api_v1_book_url(book), headers: valid_headers, as: :json
      }.to change(Book, :count).by(-1)
    end
  end
end
