class Tag < ApplicationRecord
  acts_as_nested_set
  include ::TheSortableTree::Scopes
  
  has_many :news_tags
  has_many :news, through: :news_tags
  has_many :coins
  has_many :wikis
end
