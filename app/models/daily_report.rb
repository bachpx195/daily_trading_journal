class DailyReport < ApplicationRecord
  belongs_to :coin
  belongs_to :new

  has_many :comments, as: :commentable
end
