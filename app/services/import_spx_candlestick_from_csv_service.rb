require 'csv'

class ImportSpxCandlestickFromCsvService
  def initialize
    @csv_path = Rails.root.join "db", "data_csv", "sp500_5y_20250225.csv"
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
          date: Date.strptime(row[0], "%m/%d/%Y"),
          open: row[2],
          high: row[3],
          low: row[4],
          close: row[1],
          volumn: nil,
          time_type: :day,
          merchandise_rate_id: 46
        )
      end
    end
    Candlestick.delete_duplicate
  end
end
