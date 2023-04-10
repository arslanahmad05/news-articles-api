class Author < ApplicationRecord
  validates_presence_of :name
  has_many :article_authors
  has_many :articles, through: :article_authors
end
