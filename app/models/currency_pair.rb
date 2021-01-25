class CurrencyPair < ApplicationRecord
  has_many :comments, as: :commentable
  has_many :trades
  has_many :candlesticks
  
  belongs_to :tag
  belongs_to :base, class_name: "Symbolfx"
  belongs_to :quote, class_name: "Symbolfx"

  enum is_follow: {unfollow: 0, followed: 1}
end
