class Trade < ApplicationRecord
	has_many :comments, as: :commentable
  belongs_to :coin
  has_one :trade_normal_method
  has_one :trade_pyramid_method
  
  accepts_nested_attributes_for :trade_normal_method
  accepts_nested_attributes_for :trade_pyramid_method
end
