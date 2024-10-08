# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/v1/authors', type: :request do

  let(:valid_attributes) {
    {'name'=>'Fulano', 'bio' => 'This is a bio'}
  }

  let(:invalid_attributes) {
    {'name'=>''}
  }

  let(:user_params) {
    {:email => 'admin@email.com', :password => '123456'}
  }

  let(:token) {
    @user = User.create user_params
    headers = { 'ACCEPT' => 'application/json' }
    post '/login', :params => {:email => @user.email, :password => @user.password }, :headers => headers
    JSON.parse(response.body)['token']
  }
  let(:valid_headers) {
    {'Authorization' => token }
  }

  describe 'GET /index' do
    it 'renders a successful response' do
      Author.create! valid_attributes
      get api_v1_authors_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      author = Author.create! valid_attributes
      get api_v1_authors_url(author), headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Author' do
        expect {
          post api_v1_authors_url,
               params: { author: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Author, :count).by(1)
      end

      it 'renders a JSON response with the new author' do
        post api_v1_authors_url,
             params: { author: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Author' do
        expect {
          post api_v1_authors_url,
               params: { author: invalid_attributes }, headers: valid_headers, as: :json
        }.to change(Author, :count).by(0)
      end

      it 'renders a JSON response with errors for the new author' do
        post api_v1_authors_url,
             params: { author: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) {
        {'name' => 'Fulano 2'}
      }

      it 'updates the requested author' do
        author = Author.create! valid_attributes
        patch api_v1_author_url(author),
              params: { author: new_attributes }, headers: valid_headers, as: :json
        author.reload
        expect(response).to have_http_status(:ok)
      end

      it 'renders a JSON response with the author' do
        author = Author.create! valid_attributes
        patch api_v1_author_url(author),
              params: { author: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the author' do
        author = Author.create! valid_attributes
        patch api_v1_author_url(author),
              params: { author: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested author' do
      author = Author.create! valid_attributes
      expect {
        delete api_v1_author_url(author), headers: valid_headers, as: :json
      }.to change(Author, :count).by(-1)
    end
  end
end
