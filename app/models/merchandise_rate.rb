class MerchandiseRate < ApplicationRecord
  has_many :comments, as: :commentable
  has_many :trades
  has_many :candlesticks
  has_many :event_masters
  belongs_to :tag
  belongs_to :base, class_name: "Merchandise"
  belongs_to :quote, class_name: "Merchandise"

  validates :base_id, presence: true
  validates :quote_id, presence: true

  before_create :genarate_slug
  before_update :genarate_slug

  scope :crypto_currencies, -> {where(tag_id: 8)}

  enum is_follow: {unfollow: 0, followed: 1}

  def lastest_candlestick_date interval
    candlesticks.send(interval.to_sym).sort_by_type(:desc).first&.date
  end

  def start_end_date interval="hour"
    merchandise_rate_candlestick_dates = candlesticks.send(interval.to_sym).sort_by_type(:desc).pluck(:date)
    [merchandise_rate_candlestick_dates.last, merchandise_rate_candlestick_dates.first]
  end

  private
  def genarate_slug
    return if self.slug.present?
    base = Merchandise.find(base_id)
    quote = Merchandise.find(quote_id)
    self.slug = "#{base.slug}#{quote.slug}"
  end
end
