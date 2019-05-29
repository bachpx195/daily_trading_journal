class Coin < ApplicationRecord
  has_many :coin_links
  has_many :coin_sources
	has_many :comments, as: :commentable

  belongs_to :tag
end
