class DayAnalytic < ApplicationRecord
  belongs_to :candlestick
  belongs_to :merchandise_rate

  enum candlestick_type: {increase: 0, decrease: 1}
  
  # - 0.9 <= sideway <= 0.9
  # 0.9 < increase_type <= 4
  # -4 <= decrease_type < -0.9
  # increase_strong > 4
  # decrease_strong < -4
  enum range_type: {increase_strong: 0, increase_type: 1, sideway: 2, decrease_type: 3, decrease_strong: 4}

  def previous_day
    yesterday = self.date.yesterday
    DayAnalytic.where(date: yesterday).first
  end

  def tomorrow_day
    tomorrow = self.date.tomorrow
    DayAnalytic.where(date: tomorrow).first
  end

  # Giả thuyết câu nến liên tiếp thứ 4 của nến xanh là nến xanh
  # với điều kiện cây thứ 3 có return oc < cây 2
  def self.check_continue_type date
    da = DayAnalytic.where("date > ?", date)
    total_3_continue_type = da.where(continue_type: 3).select {|x| x.return_hl < x.previous_day.return_hl}.count
    total_4_continue_type = da.where(continue_type: 3).select {|x| x.return_hl < x.previous_day.return_hl && x.tomorrow_day.continue_type == 4}.count

    # total_3_continue_type = da.where(continue_type: 3).count
    # total_4_continue_type = da.where(continue_type: 3).select {|x| x.tomorrow_day.continue_type == 4}.count

    [total_3_continue_type, total_4_continue_type]
  end

  def self.create_day_data start_date, merchandise_rate_id = 35
    count = 1

    Candlestick.where(merchandise_rate_id: merchandise_rate_id).where("date >= ?", start_date).day.order(:date).each do |c|
      # return_oc
      return_oc = ((c.close - c.open)/c.open).round(4)*100

      # range_type
      range_type = if return_oc > 4
        0
      elsif return_oc <= 4 && return_oc > 0.9
        1
      elsif return_oc <= 0.9 && return_oc >= -0.9
        2
      elsif return_oc < -0.9 && return_oc >= -4
        3
      else
        4
      end

      # is_inside_day
      day_yesterday = c.previous_day
      is_inside_day = day_yesterday.high > c.high && c.low > day_yesterday.low
      
      # is_same_btc
      btc_day = Candlestick.where(merchandise_rate_id: 34, date: c.date).day.first
      is_same_btc = (btc_day.open - btc_day.close)*(c.open - c.close) > 0

      # continue_type
      count = if (day_yesterday.open - day_yesterday.close)*(c.open - c.close) > 0
        count + 1
      else
        1
      end

      # is_fake_breakout_increase
      is_fake_breakout_increase = day_yesterday.high < c.high && c.close < day_yesterday.high

      # is_fake_breakout_decrease
      is_fake_breakout_decrease = day_yesterday.low > c.low && c.close > day_yesterday.low

      da = DayAnalytic.find_or_create_by(
        candlestick_id: c.id,
        merchandise_rate_id: c.merchandise_rate_id,
        date: c.date.to_date,
        date_name: c.date.strftime("%A")
      )
      
      Rails.logger.info c.date.to_date

      da.update({
        return_oc: return_oc,
        return_hl: ((c.high - c.low)/c.low).round(4)*100,
        candlestick_type: c.open > c.close ? 0 : 1,
        range_type: range_type,
        is_inside_day: is_inside_day,
        is_fake_breakout_increase: is_fake_breakout_increase,
        is_fake_breakout_decrease: is_fake_breakout_decrease,
        is_same_btc: is_same_btc,
        continue_type: count
      })
    end
  end

  def self.update_from_hour_analytic start_date, merchandise_rate_id
    DayAnalytic.where(merchandise_rate_id: merchandise_rate_id).where("date >= ?", start_date).each do |da|
      date = da.date
      da.update({
        highest_hour_return: HourAnalytic.get_highest_return_hour_from_day_analytics(date, merchandise_rate_id),
        reverse_decrease_hour: HourAnalytic.get_reverse_decrease_hour_from_day_analytics(date, merchandise_rate_id),
        reverse_increase_hour: HourAnalytic.get_reverse_increase_hour_from_day_analytics(date, merchandise_rate_id),
      })
    end
  end
end

