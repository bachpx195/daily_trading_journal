class Group < ApplicationRecord
  has_many :tags_groups
  has_many :tags, through: :tags_groups
end
