class HourAnalytic < ApplicationRecord
  # 7h-14h: buổi sáng, 15-19h: buổi chiều, 20h-23h: buổi tối, 0h-6h 
  # https://github.com/bachpx195/bach-s_trading_room/wiki/C%C3%A1c-phi%C3%AAn-giao-d%E1%BB%8Bch-trong-ng%C3%A0y
  belongs_to :candlestick
  belongs_to :merchandise_rate

  enum candlestick_type: {increase: 0, decrease: 1}

  # - 0.3 <= sideway <= 0.3
  # 0.3 < increase_type <= 1
  # -1 <= decrease_type < -0.3
  # increase_strong > 1
  # decrease_strong < -1
  enum range_type: {increase_strong: 0, increase_type: 1, sideway: 2, decrease_type: 3, decrease_strong: 4}

  scope :from_date, -> merchandise_rate_id, start_date do
    where("merchandise_rate_id = ? AND date >=?", merchandise_rate_id, start_date)
  end

  scope :order_by_date_and_hour, -> date_order_str = 'asc', hour_order_str = 'asc' do
    order("hour_analytics.date #{date_order_str}, hour_analytics.hour #{hour_order_str}")
  end

  scope :dup_data, -> merchandise_rate_id do
    sql = "SELECT COUNT(id) as count, merchandise_rate_id, date, hour FROM DailyTradingJournal_development.hour_analytics WHERE merchandise_rate_id = #{merchandise_rate_id} GROUP BY merchandise_rate_id, date, hour HAVING count > 1;"
    ActiveRecord::Base.connection.execute(sql)
  end

  def is_highest_hour_return_inday?
    hour_return_inday_max = HourAnalytic.where(date_with_binane: self.date_with_binane).pluck(:return_hl).max

    self.return_hl == hour_return_inday_max
  end

  def self.get_reverse_increase_hour day_with_binace
    reverse_increase_hour = nil
    highest = 0
    HourAnalytic.joins(:candlestick)
      .select('hour_analytics.hour, candlesticks.high')
      .where(date_with_binane: day_with_binace)
      .each do |ha|
        if ha.high > highest
          reverse_increase_hour = ha.hour
          highest = ha.high
        end
      end

    reverse_increase_hour
  end

  def self.get_reverse_decrease_hour day_with_binace
    reverse_decrease_hour = nil
    lowest = 10000000
    HourAnalytic.joins(:candlestick)
      .select('hour_analytics.hour, candlesticks.low')
      .where(date_with_binane: day_with_binace)
      .each do |ha|
        if ha.low < lowest
          reverse_decrease_hour = ha.hour
          lowest = ha.low
        end
      end

    reverse_decrease_hour
  end

  def self.get_reverse_increase_hour_from_day_analytics day_with_binace, merchandise_rate_id
    HourAnalytic.where(merchandise_rate_id: merchandise_rate_id, date_with_binane: day_with_binace, is_reverse_increase_hour: true)
      .first&.hour
  end

  def self.get_reverse_decrease_hour_from_day_analytics day_with_binace, merchandise_rate_id
    HourAnalytic.where(merchandise_rate_id: merchandise_rate_id, date_with_binane: day_with_binace, is_reverse_decrease_hour: true)
      .first&.hour
  end

  def self.get_highest_return_hour_from_day_analytics day_with_binace, merchandise_rate_id
    HourAnalytic.where(merchandise_rate_id: merchandise_rate_id, date_with_binane: day_with_binace, is_highest_hour_return: true)
      .first&.hour
  end

  def self.list_merchandise_rate_id
    sql = "SELECT DISTINCT merchandise_rate_id FROM DailyTradingJournal_development.hour_analytics;"
    ActiveRecord::Base.connection.execute(sql)
  end

  def self.create_hour_data start_date, merchandise_rate_id = 35
    count = 1
    candlestick_id_arr = []

    Candlestick.where(merchandise_rate_id: merchandise_rate_id).where("date >= ?", start_date).hour.order(:date).each do |c|
      # return_oc
      return_oc = ((c.close - c.open)/c.open).round(4)*100

      # candlestick_type
      candlestick_type = c.close < c.open ? 1 : 0

      # range_type
      range_type = if return_oc > 1
        0
      elsif return_oc <= 1 && return_oc > 0.3
        1
      elsif return_oc <= 0.3 && return_oc >= -0.3
        2
      elsif return_oc < -0.3 && return_oc >= -1
        3
      else
        4
      end

      # hour 
      hour = c.date.strftime("%H").to_i

      # update_is_same_btc
      btc_hour = Candlestick.where(merchandise_rate_id: 34, date: c.date).hour.first
      is_same_btc = if btc_hour.present?
        (btc_hour.open - btc_hour.close)*(c.open - c.close) > 0
      else
        false
      end

      ha = HourAnalytic.find_or_create_by(
        candlestick_id: c.id,
        merchandise_rate_id: c.merchandise_rate_id,
        hour: hour,
        date: c.date.to_date
      )
      
      Rails.logger.info "#{c.date.to_date} - #{hour}"

      ha.update({
        date_with_binane: hour < 7 ? c.date.to_date - 1.days : c.date.to_date,
        return_oc: return_oc,
        return_hl: ((c.high - c.low)/c.low).round(4)*100,
        range_type: range_type,
        candlestick_type: candlestick_type,
        is_same_btc: is_same_btc
      })
    end
  end

  def self.create_hour_data_from_id ids
    Candlestick.where(id: ids).hour.order(:date).each do |c|
      # return_oc
      return_oc = ((c.close - c.open)/c.open).round(4)*100

      # candlestick_type
      candlestick_type = c.close < c.open ? 1 : 0

      # range_type
      range_type = if return_oc > 1
        0
      elsif return_oc <= 1 && return_oc > 0.3
        1
      elsif return_oc <= 0.3 && return_oc >= -0.3
        2
      elsif return_oc < -0.3 && return_oc >= -1
        3
      else
        4
      end

      # hour 
      hour = c.date.strftime("%H").to_i

      # update_is_same_btc
      btc_hour = Candlestick.where(merchandise_rate_id: 34, date: c.date).hour.first
      btc_hour.create_candlestick_group      
      is_same_btc = if btc_hour.present?
        (btc_hour.open - btc_hour.close)*(c.open - c.close) > 0
      else
        false
      end

      ha = HourAnalytic.find_or_create_by(
        candlestick_id: c.id,
        merchandise_rate_id: c.merchandise_rate_id,
        hour: hour,
        date: c.date.to_date
      )
      
      Rails.logger.info "#{c.date.to_date} - #{hour}"

      ha.update({
        date_with_binane: hour < 7 ? c.date.to_date - 1.days : c.date.to_date,
        return_oc: return_oc,
        return_hl: ((c.high - c.low)/c.low).round(4)*100,
        range_type: range_type,
        candlestick_type: candlestick_type,
        is_same_btc: is_same_btc
      })
    end
  end

  def get_previous_day_type
    yesterday = self.date.yesterday
    hour_yesterday = HourAnalytic.where(date: yesterday, hour: self.hour)
    return nil unless hour_yesterday.present?
    hour_yesterday.first.candlestick_type
  end
end
