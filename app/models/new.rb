class New < ApplicationRecord
  has_many :news_tags
  has_many :tags, through: :news_tags
  has_many :comments, as: :commentable
  
  belongs_to :new_category
end
