# frozen_string_literal: true

class Book < ApplicationRecord
  validates :title, :price, presence: true
  belongs_to :author
end
