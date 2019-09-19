class News < ApplicationRecord
  has_many :news_tags
  has_many :tags, through: :news_tags
  has_many :comments, as: :commentable

  accepts_nested_attributes_for :news_tags, allow_destroy: true

  enum news_types: {news: 0, event: 1}
  enum status: {draft: 0, open: 1, close: 2}
end
