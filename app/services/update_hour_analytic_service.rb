class UpdateHourAnalyticService
  attr_accessor :merchandise_rate_ids, :start_date

  def initialize merchandise_rate_ids
    @merchandise_rate_ids = merchandise_rate_ids
  end

  def execute
    merchandise_rate_ids.each do |merchandise_rate_id|
      update_continuous merchandise_rate_id
    end
  end

  def update_continuous merchandise_rate_id
    hour_analytic_hash = {}
    HourAnalytic.from_date(merchandise_rate_id).order_by_date_and_hour.each do |da|
      date_str = da.date.to_s
      hour_analytic_hash[date_str] = {} if !hour_analytic_hash[date_str].present?
      hour_analytic_hash[date_str][da.hour] = da.candlestick_type
    end
    ActiveRecord::Base.transaction do
      hour_analytic_hash.keys.each_with_index |date, date_index| do
        hour_analytic_hash[date].each_with_index |hour, hour_index| do
          if date_index == 0 && hour_index == 0
            HourAnalytic.where(merchandise_rate_id: merchandise_rate_id, date: date, hour: hour).first.update(continue_by_day: 0, continue_by_hour: 0)
          if else date_index == 0
            previous_hour = hour - 1
            previous_continue_by_day = HourAnalytic.where(merchandise_rate_id: merchandise_rate_id, date: date, hour: previous_hour).first.continue_by_day
            continue_by_day = hour_analytic_hash[date][hour] == hour_analytic_hash[date][previous_hour] ? previous_continue_by_day + 1 : 0
            HourAnalytic.where(merchandise_rate_id: merchandise_rate_id, date: date, hour: hour).first.update(continue_by_day: 0, continue_by_hour: 0)
          else
            previous_date = (Date.parse(date) - 1.days).to_s
            previous_hour = hour - 1 >= 0 ? hour - 1 : 23
            previous_hour_analytic_by_day = HourAnalytic.where(merchandise_rate_id: merchandise_rate_id, date: date, hour: hour).first.continue_by_day
            previous_hour_analytic_by_hour = HourAnalytic.where(merchandise_rate_id: merchandise_rate_id, date: date, hour: hour).first.continue_by_day

            previous_continue_by_day = HourAnalytic.where(merchandise_rate_id: merchandise_rate_id, date: date, hour: hour).first.continue_by_day

          end
        end
      end
    end
  end
end