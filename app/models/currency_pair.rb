class CurrencyPair < ApplicationRecord
  has_many :comments, as: :commentable
  
  belongs_to :tag
  belongs_to :base, class_name: "Symbolfx"
  belongs_to :quote, class_name: "Symbolfx"

  enum is_follow: {unfollow: 0, followed: 1}
end
