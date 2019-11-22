# frozen_string_literal: true

require 'csv'

class LogImporter
  attr_reader :files, :csv_file, :logs, :errors
  
  def initialize(files)
    @files = files
    @errors = []
    @logs = []
  end
  
  def execute
    @csv_file = if files.instance_of?(Array)
                  files.find { |f| File.extname(f.original_filename).casecmp('.csv').zero? }
                elsif files.instance_of?(ActionController::Parameters)
                  files.values.find { |f| File.extname(f.original_filename).casecmp('.csv').zero? }
                else
                  files
                end

    return if @csv_file.blank?
    
    CSV.foreach(
      csv_file.path,
      headers: true,
      header_converters: lambda { |f| f.strip },
      converters: lambda { |f| f ? f.strip : nil }
    ).with_index do |row, i|
      trade = Trade.new(
        currency_pair_id: get_currency_pair_id(row['Symbol']),
        start_date: get_datetime_server(row['Open Time']),
        end_date: get_datetime_server(row['Close Time']),
        order_type: get_order_type(row['Action']),
        trade_normal_method_attributes: {point_entry: row['Open Price'].to_f, point_out: row['Close Price'].to_f},
        log_attributes: { server_code: row['Ticket'],
         status: get_log_status(row['Profit'], row['Comm.'], row['Sw.']),
         fee: row['Comm.'].to_f + row['Sw.'].to_f,
         money: row['Profit'].to_f, datetime: Time.zone.now}
      )
      @logs << trade
      @errors << "[Lỗi:#{i + 1}] #{trade.errors.full_messages.to_sentence}"  unless trade.valid?
    end
    
    return if @errors.present?
    create_logs
  end
  
  private
  
  def get_log_status str, fee, swap
    profit = str.to_f + fee.to_f + swap.to_f
    if str.to_f <= 5 || str.to_f >= -5
      0
    elsif str.to_f > 5
      1
    else
      2
    end
  end
  
  def get_order_type str
    if str == 'SELL'
      0
    else
      1
    end
  end
  
  def get_datetime_server str
    return unless str.present?
    str1 = str.split(" ")
    DateTime.strptime("#{str1[2]}-#{str1[1]}-#{str1[0]} #{str1[3]}", '%Y-%B-%d %H:%M').utc
  end
  
  def get_currency_pair_id str
    # if str.include? 'XAU'
    #   return CurrencyPair.find_by(slug: 'XAU/USD').id
    # end
    # symbol_arr = []
    # Symbolfx.pluck(:slug).each do |symbol|
    #   symbol_arr << symbol if str.include? symbol
    # end
    #
    # symbol_pair = symbol_arr.join('/')
    # symbol_pair_reverse = symbol_arr&.reverse.join('/')
    #
    # currency = nil
    #
    # if symbol_pair.present?
    #   currency = CurrencyPair.find_by(slug: symbol_pair) || CurrencyPair.find_by(slug: symbol_pair_reverse)
    # end
    #
    # currency.id
    #
    CurrencyPair.first.id
  end
  
  def create_logs
    @logs.each do |log|
      next unless log.save
    end
  end
end
