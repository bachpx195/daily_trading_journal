require 'json'

class CandlestickImporter
  attr_reader :files, :csv_file, :candlesticks, :errors

  def initialize(currency_pair,files=false)
    @currency_pair = currency_pair
    @files = files
    @errors = []
    @candlesticks = []
  end

  def execute
    if @files
      json_list = JSON.parse(File.read(@files.path))

      json_list.each do |record|
          @currency_pair.candlesticks.create!(date: Time.at(record[0]/1000).to_datetime, open: record[1], high: record[2], low: record[3], close: record[4], volumn: record[5])
      end
    end
  end
end
