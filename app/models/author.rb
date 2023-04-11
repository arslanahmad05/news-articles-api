class Author < ApplicationRecord
  validates_presence_of :name
  has_many :articles
end
