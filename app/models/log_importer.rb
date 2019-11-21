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
      log = Log.new(
        server_code: row['Ticket'],
        name_kana: row['店舗名カナ'],
        brand: row['ブランド'],
        address: row['住所*'],
        phone_number: row['電話番号*'],
        email: row['メールアドレス'],
        access: row['アクセス'],
        post_code: row['郵便番号'],
        city_id: city.id
      )
      
      trade = Trade.new(
        currency_pair_id: get_currency_pair_id(row['Symbol']),
        start_date: get_datetime_server(row['Open Time']),
        end_date: get_datetime_server(row['Close Time']),
        order_type: get_order_type(row['Action'])
      )
      @errors << "[案件一覧:#{i + 1}][ポジション] #{branch.errors.full_messages.to_sentence}"  unless branch.valid?
      @branches << branch
    end
    
    return if @errors.present?
    create_logs
  end
  
  private
  
  def get_order_type str
    if str == 'SELL'
      0
    else
      1
    end
  end
  
  def get_datetime_server str
    return unless str.present?
    DateTime.strptime("#{str[2]}-#{str[1]}-#{str[0]} #{str[3]}", '%Y-%B-%d %H:%M').utc
  end
  
  def get_currency_pair_id str
    if str.include? 'XAU'
      return CurrencyPair.find_by(slug: 'XAU/USD').id
    end
    symbol_arr = []
    Symbolfx.pluck(:slug).each do |symbol|
      symbol_arr << symbol if str.include? symbol
    end

    symbol_pair = symbol_arr.join('/')
    symbol_pair_reverse = symbol_arr&.reverse.join('/')

    currency = nil
    
    if symbol_pair.present?
      currency = CurrencyPair.find_by(slug: symbol_pair) || CurrencyPair.find_by(slug: symbol_pair_reverse)
    end

    currency.id
  end
  
  def create_logs
    @logs.each do |log|
      next unless log.save
    end
  end
end
