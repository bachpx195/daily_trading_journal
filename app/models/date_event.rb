class DateEvent < ApplicationRecord
  belongs_to :date_master
  belongs_to :event_master
  belongs_to :merchandise_rate, optional: true
  belongs_to :day_analytic, optional: true

  class << self
    def create_nfp_data
      nfp_event_id =  EventMaster.nfp.id
      (2008..2029).each do |year|
        (1..12).each do |month|
          nfp_date = DateMaster.where(date_name: "Friday", month: month, year: year).order(date_number: :asc).first
          if nfp_date
            DateEvent.create(
              event_master_id: nfp_event_id,
              date_master_id: nfp_date.id
            )
          end
        end
      end
    end
  end
end
