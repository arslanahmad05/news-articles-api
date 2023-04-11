class Article < ApplicationRecord

  belongs_to :topic, optional: true
  belongs_to :author, optional: true

  validates_presence_of :title, :description, :content, :article_url, :published_at

end
