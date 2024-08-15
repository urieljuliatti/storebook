require 'rails_helper'

RSpec.describe Author, type: :model do
  context 'validating presence of name' do
    it 'expect to be valid' do
      expect(Author.new(name: 'Uriel')).to be_valid
    end
  end
end
