class NewsSite < ApplicationRecord
	has_many :comments, as: :commentable
  belongs_to :tag
end
