module DataValidations
  class DayAnalyticValidationService
    attr_accessor :merchandise_rate_id

    def initialize merchandise_rate_id
      @merchandise_rate_id = merchandise_rate_id
    end

    def execute
      result = check_missing_day merchandise_rate_id
      result
    end

    private
    def check_missing_day merchandise_rate_id
      date_arr = DayAnalytic.where(merchandise_rate_id: merchandise_rate_id).order(date: :asc).pluck(:date)
      day_missing = []
      date_arr.each_with_index do |day, index|
        if index != date_arr.length - 1
          day_missing << day + 1.days if day + 1.days != date_arr[index + 1]
        end
      end

      day_missing
    end
  end
end