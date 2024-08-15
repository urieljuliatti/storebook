require 'rails_helper'

RSpec.describe Book, type: :model do
  context 'validating presence of' do
    before(:each) do
      @author = Author.create(name: 'Fulano')
    end
    it 'expect to be valid' do
      expect(Book.create(title: 'Frankenstein', author_id: @author.id)).to be_valid
    end
  end
end
