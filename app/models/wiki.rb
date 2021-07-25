class Wiki < ApplicationRecord
  has_many :comments, as: :commentable
  belongs_to :tag

  scope :crypto_and_common, -> {
    where(market_type: [1, 3])
  }

  scope :forex_and_common, -> {
    where(market_type: [0, 3])
  }

  mount_uploader :image, ImageUploader
  enum market_type: {common:0, forex: 1, crypto: 2, commodity: 3}
end
