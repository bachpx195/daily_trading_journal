class CurrencyPair < ApplicationRecord
  has_many :comments, as: :commentable
  
  belongs_to :tag
  belongs_to :base, class_name: "Symbolfx"
  belongs_to :quote, class_name: "Symbolfx"
end
