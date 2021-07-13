class MerchandiseRate < ApplicationRecord
  has_many :comments, as: :commentable
  has_many :trades
  has_many :candlesticks
  belongs_to :tag
  belongs_to :base, class_name: "Merchandise"
  belongs_to :quote, class_name: "Merchandise"

  validates :base_id, presence: true
  validates :quote_id, presence: true

  before_create :genarate_slug
  
  enum is_follow: {unfollow: 0, followed: 1}

  private
  def genarate_slug
    return if self.slug.present?
    base = Merchandise.find(base_id)
    quote = Merchandise.find(quote_id)
    self.slug = "#{base.slug}#{quote.slug}"
  end
end
