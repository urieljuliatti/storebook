require 'rails_helper'

RSpec.describe Book, type: :model do
  context 'validating presence of' do
    it 'expect to be valid' do
      expect(Book.new(title: 'Frankenstein')).to be_valid
    end
  end
end
