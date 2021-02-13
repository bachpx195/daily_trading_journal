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
          @currency_pair.candlesticks.create!(date: Time.at(record[0]/1000).to_datetime, open: record[1], high: record[2], low: record[3], close: record[4])
      end
    else
      uri = URI('http://example.com/index.html')
      params = { :limit => 10, :page => 3 }
      uri.query = URI.encode_www_form(params)

      res = Net::HTTP.get_response(uri)
      puts res.body if res.is_a?(Net::HTTPSuccess)
    end
  end
end
