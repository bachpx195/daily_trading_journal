class Log < ApplicationRecord
  belongs_to :trade
	has_many :logs
	
	scope :order_desc, -> {order(datetime: :desc)}
	scope :get_logs_by_date, ->date {where("DATE(datetime) = ?", date).success}
	scope :get_logs_by_month, ->start_date, end_date  {where("datetime > ? AND datetime < ?", start_date, end_date).success}

	validates :name, :money, :datetime, presence: true
	validates :money, numericality: {only_float: true}

  enum status: {break_even: 0, interest: 1, loss: 2}
end
