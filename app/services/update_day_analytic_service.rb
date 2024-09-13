class UpdateDayAnalyticService
  attr_accessor :merchandise_rate_ids, :start_date

  def initialize merchandise_rate_ids, start_date
    @merchandise_rate_ids = merchandise_rate_ids
    @start_date = start_date
  end

  def execute
    merchandise_rate_ids.each do |merchandise_rate_id|
      update_day_analytic merchandise_rate_id
    end
  end

  def update_day_analytic merchandise_rate_id
    DayAnalytic.from_date(merchandise_rate_id, start_date).each do |da|
      next if !da.is_completion_date?

      Rails.logger.info(da.date)
      da.calculate_hour_analytic_for_day
    end
  end
end