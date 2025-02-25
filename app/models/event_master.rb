class EventMaster < ApplicationRecord
  has_many :date_events
  has_many :date_masters, through: :date_events

  belongs_to :merchandise_rate, optional: true
  class << self
    def create_data
      # NFP
      EventMaster.create!(
        name: "NonFarm Payroll",
        slug: "NFP",
        description: "update...",
        time: "tối thứ 6 đầu tiên của tháng",
        note: "https://github.com/bachpx195/the_big_trade/issues/43"
      )

      # CPI
      EventMaster.create!(
        name: "Consumer Price Index",
        slug: "CPI",
        description: "update...",
        time: "Thường vào nửa đầu mỗi tháng",
        note: "https://github.com/bachpx195/the_big_trade/issues/39"
      )

      # FIR
      EventMaster.create!(
        name: "Fed Interest Rate",
        slug: "FIR",
        description: "update...",
        time: "8 đợt mỗi năm",
        note: "https://github.com/bachpx195/the_big_trade/issues/46"
      )
    end

    def nfp
      where(slug: "NFP").first
    end
  end
end
