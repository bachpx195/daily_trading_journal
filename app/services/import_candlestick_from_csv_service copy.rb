require 'csv'

class ImportCandlestickFromCsvService
  def initialize
    @csv_path = Rails.root.join "db", "data_csv", "data-usdtd-day.csv"
    puts @csv_path
  end

  def execute
    create_candlesticks
  end

  private

  def create_candlesticks
    # file = File.read(@csv_path).encode("UTF-8")
    ActiveRecord::Base.transaction do  
      CSV.foreach(
        @csv_path,
        headers: true
      ) do |row|
        Candlestick.create(
          date: Time.zone.parse(row[0]),
          open: row[2],
          high: row[3],
          low: row[4],
          close: row[5],
          volumn: row[6],
          time_type: :day,
          merchandise_rate_id: 45
        )
      end
    end
    Candlestick.delete_duplicate
  end
end
