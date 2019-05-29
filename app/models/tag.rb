class Tag < ApplicationRecord
  has_many :news_tags
  has_many :news, through: :news_tags
  has_many :tags_groups
  has_many :groups, through: :tags_groups
end
