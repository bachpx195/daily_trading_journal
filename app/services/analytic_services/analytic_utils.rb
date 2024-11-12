module AnalyticServices
  module AnalyticUtils
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
end