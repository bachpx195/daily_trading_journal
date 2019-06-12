class Trade < ApplicationRecord
	has_many :comments, as: :commentable
  belongs_to :coin
  has_one :trade_normal_method
  has_one :trade_pyramid_method
end
