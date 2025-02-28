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

  scope :from_date, -> merchandise_rate_id, start_date do
    where("date >= ? AND merchandise_rate_id = ?", start_date, merchandise_rate_id)
  end

  scope :not_update_hour_analytic, -> merchandise_rate_id do
    where("highest_hour_return is null AND highest_hour_volumn is null AND reverse_decrease_hour is null AND reverse_increase_hour is null AND merchandise_rate_id = ?", merchandise_rate_id)
    .order(date: :desc)
  end

  def previous_day
    yesterday = self.date.yesterday
    DayAnalytic.where(date: yesterday).first
  end

  def tomorrow_day
    tomorrow = self.date.tomorrow
    DayAnalytic.where(date: tomorrow).first
  end

  # Mot ngay day du co 24h
  def is_completion_date?
    HourAnalytic.where(date_with_binane: self.date, merchandise_rate_id: self.merchandise_rate_id).count == 24
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

  def self.create_day_data start_date, merchandise_rate_id = 35, end_date = nil
    count = 1

    candlesticks = if start_date.present? && end_date.present?
      Candlestick.where(merchandise_rate_id: merchandise_rate_id).where("date between ? and ?", start_date, end_date).day.order(:date)
    else
      Candlestick.where(merchandise_rate_id: merchandise_rate_id).where("date >= ?", start_date).day.order(:date)
    end

    candlesticks.each do |c|
      date = c.date

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
      is_inside_day = if day_yesterday.present?
        day_yesterday.high > c.high && c.low > day_yesterday.low
      else
        false
      end
      
      # is_same_btc

      btc_day = Candlestick.where(merchandise_rate_id: 34, date: date).day.first
      is_same_btc = if btc_day.present?
        (btc_day.open - btc_day.close)*(c.open - c.close) > 0
      else
        false
      end

      # continue_type
      count = if day_yesterday.present? && (day_yesterday.open - day_yesterday.close)*(c.open - c.close) > 0
        count + 1
      else
        1
      end

      if day_yesterday.present?
        # is_fake_breakout_increase
        is_fake_breakout_increase = day_yesterday.high < c.high && c.close < day_yesterday.high

        # is_fake_breakout_decrease
        is_fake_breakout_decrease = day_yesterday.low > c.low && c.close > day_yesterday.low
      else
        is_fake_breakout_increase = false
        is_fake_breakout_decrease = false
      end


      da = DayAnalytic.find_or_create_by(
        candlestick_id: c.id,
        merchandise_rate_id: c.merchandise_rate_id,
        date: date.to_date,
        date_name: date.strftime("%A")
      )
      
      Rails.logger.info date.to_date

      da.update({
        return_oc: return_oc,
        return_hl: ((c.high - c.low)/c.low).round(4)*100,
        candlestick_type: c.open > c.close ? 1 : 0,
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

  def self.list_merchandise_rate_id
    sql = "SELECT DISTINCT merchandise_rate_id FROM DailyTradingJournal_development.day_analytics;"
    ActiveRecord::Base.connection.execute(sql)
  end

  def calculate_hour_analytic_for_day
    tmp_highest_hour_return = nil
    highest_return = 0

    tmp_highest_hour_volumn = nil
    highest_volumn = 0

    tmp_reverse_increase_hour = nil
    highest = 0

    tmp_reverse_decrease_hour = nil
    lowest = 10000000

    HourAnalytic.joins(:candlestick)
      .select('hour_analytics.hour, hour_analytics.return_hl, candlesticks.high, candlesticks.low, candlesticks.volumn')
      .where(date_with_binane: self.date, merchandise_rate_id: self.merchandise_rate_id)
      .each do |ha|
        hour = ha.hour

        # reverse_decrease_hour
        if ha.low < lowest
          tmp_reverse_decrease_hour = hour
          lowest = ha.low
        end

        # reverse_increase_hour
        if ha.high > highest
          tmp_reverse_increase_hour = hour
          highest = ha.high
        end

        # highest_hour_return
        if ha.return_hl > highest_return
          tmp_highest_hour_return = hour
          highest_return = ha.return_hl
        end

        # highest_hour_volumn
        if ha.volumn > highest_volumn
          tmp_highest_hour_volumn = hour
          highest_volumn = ha.volumn
        end
      end

    self.update(
      highest_hour_return: tmp_highest_hour_return,
      highest_hour_volumn: tmp_highest_hour_volumn,
      reverse_decrease_hour: tmp_reverse_decrease_hour,
      reverse_increase_hour: tmp_reverse_increase_hour
    )
  end
end

