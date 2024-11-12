module AnalyticServices
  class CreateAnalyticService
    include AnalyticUtils

    attr_accessor :merchandise_rate_ids, :start_date

    def initialize merchandise_rate_ids, start_date=nil
      @merchandise_rate_ids = merchandise_rate_ids
      @start_date = start_date
    end

    def execute
      merchandise_rate_ids.each do |merchandise_rate_id|
        create_day_analytic merchandise_rate_id
      end
    end

    private
    def create_day_analytic merchandise_rate_id
      create_month_data merchandise_rate_id
      # AnalyticHour.create_hour_data start_date, merchandise_rate_id
      # DayAnalytic.create_day_data Date.parse(start_date), merchandise_rate_id

      # UpdateDayAnalyticService.new([merchandise_rate_id], start_date)
    end


    def create_month_data merchandise_rate_id = 35
      Rails.logger.info "____________________merchandise_rate_id #{merchandise_rate_id}"

      start_date = Date.parse(start_date) if start_date.present?

      candlesticks = Candlestick.where(merchandise_rate_id: merchandise_rate_id).month
      candlesticks.where("date >= ?", start_date) if start_date.present?

      analytic_month_arr = []

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

        analytic_month_arr << ha.id
      end
    end
  end
end