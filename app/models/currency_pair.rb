class CurrencyPair < ApplicationRecord
  has_many :comments, as: :commentable
  has_many :trades
<<<<<<< HEAD

=======
  has_many :candlesticks
>>>>>>> 612f21f (upload)
  belongs_to :tag
  belongs_to :base, class_name: "Merchandise"
  belongs_to :quote, class_name: "Merchandise"

  enum is_follow: {unfollow: 0, followed: 1}
end
