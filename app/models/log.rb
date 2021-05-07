class Log < ApplicationRecord
  belongs_to :trade
	has_many :fund_logs

	before_create :genarate_code
	after_save :update_fund_log

	scope :order_desc, -> {order(datetime: :desc)}
	scope :get_logs_by_date, ->date {where("DATE(datetime) = ?", date).success}
	scope :get_logs_by_month, ->start_date, end_date  {where("datetime > ? AND datetime < ?", start_date, end_date).success}

  enum status: {break_even: 0, interest: 1, loss: 2}

	private

	def genarate_code
		self.code =  self.trade.merchandise_rate.slug.upcase + self.created_at.to_i.to_s
	end

	def update_fund_log
		return unless self.status.present?
		ActiveRecord::Base.transaction do
			if self.money + self.fee < 0
				self.fund_logs.create! change_type: :loss, change_amount: self.money
				self.fund_logs.create! change_type: :fee, change_amount: self.fee
			else
				self.fund_logs.create! change_type: :profit, change_amount: self.money
				self.fund_logs.create! change_type: :fee, change_amount: self.fee
			end
		end
	end
end
