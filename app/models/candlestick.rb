require 'active_record'
require 'activerecord-import'

class Candlestick < ApplicationRecord
  belongs_to :merchandise_rate
  has_one :analytic_day, dependent: :destroy
  has_one :analytic_hour, dependent: :destroy
  has_one :analytic_week, dependent: :destroy
  has_one :analytic_month, dependent: :destroy


  has_one :day_analytic, dependent: :destroy
  has_one :hour_analytic, dependent: :destroy
  has_one :candlestick_info, dependent: :destroy
  enum time_type: {day: 1, week: 2, month: 3, hour: 4, m15: 5}

  # date_between( "2022-05-10","2022-05-12")
  scope :date_between, -> start_date, end_date do
    where("date >= ? AND date <= ?", start_date.to_date.beginning_of_day, end_date.to_date.end_of_day )
  end

  scope :time_between, -> start_time, end_time do
    where("date >= ? AND date <= ?", start_time, end_time )
  end

  scope :find_by_merchandise_rate, -> merchandise_rate_id, time_type, limit do
    where(merchandise_rate_id: merchandise_rate_id)
    .where(time_type: time_type)
    .limit(limit)
    .order(date: :desc)
  end

  scope :find_monthly_candlestick, -> merchandise_rate_id do
    where(merchandise_rate_id: merchandise_rate_id)
    .where(time_type: 3)
    .order(date: :desc)
  end

  # :desc, :asc
  scope :sort_by_type, -> sort_type do
    order(date: sort_type)
  end

  class << self
    def delete_duplicate
      Candlestick.where.not(id: Candlestick.group(:date, :time_type, :merchandise_rate_id).select("min(id)")).destroy_all
    end

    # Mục đích là tìm 100 giá trị trước và sau date được chọn
    def range_between_date date, type, limit
      case type
      when time_types["day"]
        [date - 100.days, date + limit.days, date + 1.days]
      when time_types["week"]
        [date - 100.weeks, date + limit.weeks, date + 1.weeks]
      when time_types["month"]
        [date - 100.months, date + limit.months, date + 1.months]
      when time_types["hour"]
        [date - 100.hours, date + limit.hours, date + 1.hours]
      when time_types["m15"]
        [date - (100*15).minutes, date + (limit*15).minutes, date + 15.minutes]
      end
    end

    def list_merchandise_rate_id
      sql = "SELECT DISTINCT merchandise_rate_id FROM DailyTradingJournal_development.candlesticks;"
      ActiveRecord::Base.connection.execute(sql)
    end

    def calculate_month_return merchandise_rate_id, using_markdown_text = false
      candlesticks = Candlestick.find_monthly_candlestick(merchandise_rate_id)
      monthly_return_json = {}

      candlesticks.each do |c|
        current_time = Time.zone.now
        c_date = c.date
        c_year = c_date.year
        c_month = c_date.month 
        next if c_year == current_time.year && c_month == current_time.month
        monthly_return_json[c_year] = {} if !monthly_return_json[c_year].present?
        monthly_return = ((c.close - c.open)*100/c.open).round(2)

        monthly_return_json[c_year][c_month] = if using_markdown_text
          color = monthly_return > 0 ? 'green' : 'red'
          text = monthly_return > 0 ? "+#{monthly_return}" : "-#{monthly_return.abs}"
          "$${\\color{#{color}}#{text}}$$"
        else
          monthly_return
        end
      end

      if using_markdown_text
        monthly_return_json.keys.each do |key|
          monthly_return_json[key] = monthly_return_json[key].values.reverse.join("|")
        end
      end

      monthly_return_json
    end

    # Cap nhat group cac candlestick
    def update_candlestick_group
      ids = GroupCandlestick.pluck(:candlestick_id)
      Candlestick.where(merchandise_rate_id: 34).where.not(id: ids).where.not(time_type: "m15").each do |ca|
        ca.create_candlestick_group
      end
    end
  end

  def previous_day(mr_id=nil)
    yesterday = if self.day?
      self.date.yesterday
    else
      self.date.beginning_of_day.yesterday.strftime('%Y-%m-%d')
    end
    Candlestick.where(merchandise_rate_id: mr_id.present? ? mr_id : self.merchandise_rate_id, date: yesterday).day.first
  end

  def previous_hour(mr_id=nil)
    previous_hour = self.date - 1.hours
    Candlestick.where(merchandise_rate_id: mr_id.present? ? mr_id : self.merchandise_rate_id, date: previous_hour).hour.first
  end

  def previous_24_hour(mr_id=nil)
    previous_hour = self.date - 24.hours
    Candlestick.where(merchandise_rate_id: mr_id.present? ? mr_id : self.merchandise_rate_id, date: previous_hour).hour.first
  end

  def other_candlestick mr_id
    Candlestick.where(merchandise_rate_id: mr_id, date: self.date, time_type: self.time_type).first
  end

  def create_candlestick_group
    return if self.merchandise_rate_id != 34
    return if self.time_type == "m15"
    gc = GroupCandlestick.find_or_create_by!(candlestick_id: self.id)

    Candlestick.where(date: self.date, time_type: self.time_type).each do |ca|
      ci = CandlestickInfo.find_by(candlestick_id: ca.id)
      if ci.present?
        ci.update!(group_candlestick_id: gc.id)
      else
        CandlestickInfo.create!(candlestick_id: ca.id, group_candlestick_id: gc.id, merchandise_rate_id: ca.merchandise_rate_id)
      end
    end
  end

  def create_parent_id
    return if self.merchandise_rate_id != 34 || self.time_type == "m15"
    return if self.time_type == "m15"
    gc = GroupCandlestick.find_or_create_by!(candlestick_id: self.id)

    Candlestick.where(date: self.date, time_type: self.time_type).each do |ca|
      ci = CandlestickInfo.find_by(candlestick_id: ca.id)
      if ci.present?
        ci.update!(group_candlestick_id: gc.id)
      else
        CandlestickInfo.create!(candlestick_id: ca.id, group_candlestick_id: gc.id)
      end
    end
  end
end
