class UpdateHourAnalyticService
  attr_accessor :merchandise_rate_id, :start_date

  def initialize merchandise_rate_id, start_date
    @merchandise_rate_id = merchandise_rate_id
    @start_date = start_date
  end

  def execute
    update_continuous merchandise_rate_id
  end

  def update_continuous merchandise_rate_id
    # Check dup data
    if HourAnalytic.dup_data(merchandise_rate_id).count > 0
      raise Exception.new("merchandise_rate_id #{merchandise_rate_id} co data bi duplicate, can clear truoc khi tinh toan continuous")
    end

    hour_analytic_hash = {}
    HourAnalytic.from_date(merchandise_rate_id, start_date).order_by_date_and_hour.each do |da|
      date_str = da.date.to_s
      hour_analytic_hash[date_str] = {} if !hour_analytic_hash[date_str].present?
      hour_analytic_hash[date_str][da.hour] = da.candlestick_type
    end
    hour_analytic_hash.keys.each_with_index do |date, date_index|
      hour_analytic_hash[date].keys.each_with_index do |hour, hour_index|
        hour_analytic = HourAnalytic.where(merchandise_rate_id: merchandise_rate_id, date: date, hour: hour).first
        previous_date = (Date.parse(date) - 1.days).to_s
        previous_hour = hour - 1 >= 0 ? hour - 1 : 23
        puts "#{date} #{hour}"
        # Truong hop ngay va gio dau tien chua co du lieu
        if date_index == 0 && hour_index == 0
          hour_analytic.update(continue_by_day: 1, continue_by_hour: 1)
        # Truong hop gio trong ngay dau tien chua co du lieu continue by hour
        elsif date_index == 0
          previous_hour_analytic_by_day = if previous_hour == 23
            HourAnalytic.where(merchandise_rate_id: merchandise_rate_id, date: previous_date, hour: previous_hour).first
          else
            HourAnalytic.where(merchandise_rate_id: merchandise_rate_id, date: date, hour: previous_hour).first
          end
          continue_by_day = if !previous_hour_analytic_by_day
            1
          elsif previous_hour_analytic_by_day.candlestick_type == hour_analytic.candlestick_type
            previous_hour_analytic_by_day.continue_by_day.to_i + 1
          else
            1
          end
          hour_analytic.update(continue_by_day: continue_by_day, continue_by_hour: 1)
        else
          previous_date = (Date.parse(date) - 1.days).to_s
          previous_hour = hour - 1 >= 0 ? hour - 1 : 23
          previous_hour_analytic_by_day = if previous_hour == 23
            HourAnalytic.where(merchandise_rate_id: merchandise_rate_id, date: previous_date, hour: previous_hour).first
          else
            HourAnalytic.where(merchandise_rate_id: merchandise_rate_id, date: date, hour: previous_hour).first
          end
          previous_hour_analytic_by_hour = HourAnalytic.where(merchandise_rate_id: merchandise_rate_id, date: previous_date, hour: hour).first
          hour_analytic = HourAnalytic.where(merchandise_rate_id: merchandise_rate_id, date: date, hour: hour).first

          continue_by_day = if !previous_hour_analytic_by_day
            1
          elsif previous_hour_analytic_by_day.candlestick_type == hour_analytic.candlestick_type
            previous_hour_analytic_by_day.continue_by_day.to_i + 1
          else
            1
          end

          continue_by_hour = if !previous_hour_analytic_by_hour
            1
          elsif previous_hour_analytic_by_hour.candlestick_type == hour_analytic.candlestick_type
            previous_hour_analytic_by_hour.continue_by_hour.to_i + 1
          else
            1
          end

          hour_analytic.update(continue_by_day: continue_by_day, continue_by_hour: continue_by_hour)
        end
      end
    end
  end
end