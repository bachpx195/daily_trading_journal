# start_date:date month:integer year:integer overlap_month:integer number_in_month:integer

class WeekMaster < ApplicationRecord
  has_many :date_masters

  class << self
    def create_data(first_date, last_date)
      first_date = Date.parse(first_date)
      last_date = Date.parse(last_date)

      while first_date <= last_date
        puts first_date
        WeekMaster.create(start_date: first_date, month: first_date.month, year: first_date.year)
        first_date = first_date + 7
      end
    end

    def update_overlap_month
      WeekMaster.all.each do |wm|
        start_date = wm.start_date
        end_date = start_date + 7
        end_date_month = end_date.month
        wm.update(overlap_month: end_date_month) if (wm.month != end_date_month)
      end
    end

    def update_number_in_month
      WeekMaster.all.each do |wm|
        start_date = wm.start_date

        pre_number = WeekMaster.where("week_masters.start_date < ? AND week_masters.month = ? AND week_masters.year = ?", wm.start_date, wm.month, wm.year).count
       
        wm.update(number_in_month: pre_number + 1) 
      end
    end
  end
end
