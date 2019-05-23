class New < ApplicationRecord
  has_many :news_tags
  has_many :tags, through: :news_tags
  
  belongs_to :new_category
end
