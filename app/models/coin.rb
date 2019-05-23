class Coin < ApplicationRecord
  has_many :coin_links
  has_many :coin_sources
  
  belongs_to :coin_category
end
