require 'date'

class CreateDayAnalyticService
  attr_accessor :merchandise_rate_ids, :start_date

  def initialize merchandise_rate_ids, start_date
    @merchandise_rate_ids = merchandise_rate_ids
    @start_date = start_date
  end

  def execute
    merchandise_rate_ids.each do |merchandise_rate_id|
      create_day_analytic merchandise_rate_id
    end
  end

  def create_day_analytic merchandise_rate_id
    HourAnalytic.create_hour_data Date.parse(start_date), merchandise_rate_id
    DayAnalytic.create_day_data Date.parse(start_date), merchandise_rate_id

    UpdateDayAnalyticService.new([merchandise_rate_id], start_date).execute
  end
end