class AnalyticMonth < ApplicationRecord
  has_one :report_month, dependent: :destroy

  belongs_to :candlestick
  belongs_to :merchandise_rate

  # return_oc
  # return_hl
  # candlestick_type
  # month
  # year
  # is_same_btc
  def self.create_month_data start_date, merchandise_rate_id = 35
    Rails.logger.info "____________________merchandise_rate_id #{merchandise_rate_id}"

    start_date = Date.parse(start_date) if start_date.present?

    candlesticks = Candlestick.where(merchandise_rate_id: merchandise_rate_id).month
    candlesticks.where("date >= ?", start_date) if start_date.present?

    candlesticks.order(:date).each do |c|

      # candlestick_type
      candlestick_type = cal_candlestick_type c

      c_date = c.date
      # month 
      month = cal_month c_date

      # year
      year = cal_year c_date

      # is_same_btc
      is_same_btc = cal_is_same_btc c_date, c

      ha = AnalyticMonth.find_or_create_by(
        candlestick_id: c.id,
        merchandise_rate_id: c.merchandise_rate_id,
        month: month,
        year: year,
      )
      
      Rails.logger.info "merchandise_rate_id #{merchandise_rate_id} #{c.date.to_date} - #{month}/#{year}"

      ha.update!({
        return_oc: cal_return_oc(c),
        return_hl: cal_return_hl(c),
        candlestick_type: candlestick_type,
        is_same_btc: is_same_btc
      })
    end
  end

  private
  
  def cal_return_oc c
    ((c.close - c.open)/c.open).round(4)*100
  end

  def cal_return_hl c
    ((c.high - c.low)/c.low).round(4)*100
  end

  def cal_candlestick_type c
    candlestick_type = c.close < c.open ? 'increase' : 'decrease'
    candlestick_type
  end

  def cal_month c_date
    c_date.strftime("%m").to_i
  end

  def cal_year c_date
    c_date.strftime("%Y").to_i
  end

  def cal_is_same_btc c_date, c
    btc_month = Candlestick.where(merchandise_rate_id: 34, date: c_date).month.first
    is_same_btc = if btc_month.present?
      (btc_month.open - btc_month.close)*(c.open - c.close) > 0
    else
      false
    end
    is_same_btc
  end
end
