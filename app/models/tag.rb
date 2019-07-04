class Tag < ApplicationRecord
  acts_as_nested_set
  
  has_many :news_tags
  has_many :news, through: :news_tags
  has_many :coins
end
