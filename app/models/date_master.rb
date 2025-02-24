class DateMaster < ApplicationRecord
  has_many :date_events
  has_many :event_masters, through: :date_events
  belongs_to :week_master, optional: true

  class << self
    def create_data
      first_date = Date.parse('2008-01-07')
      last_date = Date.parse('2029-12-31')
      dates_master = [] 

      while first_date <= last_date
        puts first_date
        dates_master.push(DateMaster.new(
          date: first_date,
          date_name: first_date.strftime("%A"),
          date_number: first_date.day,
          month: first_date.month,
          year: first_date.year,
          week_master_id: WeekMaster.find_by(start_date: first_date.at_beginning_of_week).id
        ))
        first_date = first_date + 1
      end

      DateMaster.import(dates_master, validate: false)
    end
  end
end
