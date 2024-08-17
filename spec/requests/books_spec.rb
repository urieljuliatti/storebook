# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Books', type: :request do

  let(:valid_attributes) {
    @author = Author.create(name: 'Fulano')
    {'title'=>'foo', 'body'=>'foo', 'author_id' => @author.id, 'price' => '10.00' }
  }
  before(:each) do
    @book = Book.create! valid_attributes
  end
  describe 'GET /index' do
    it 'renders a successful response' do
      get books_url, as: :json
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get book_url(@book), as: :json
      expect(response).to be_successful
    end
  end
end
