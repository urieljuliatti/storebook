require 'rails_helper'

RSpec.describe "Books", type: :request do

  let(:valid_attributes) {
    @author = Author.create(name: 'Fulano')
    {'title'=>'foo', 'body'=>'foo', 'author_id' => @author.id }
  }

  describe 'GET /show' do
    it 'renders a successful response' do
      book = Book.create! valid_attributes
      get book_url(book), as: :json
      expect(response).to be_successful
    end
  end

end
