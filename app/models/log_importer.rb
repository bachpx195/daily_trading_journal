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
      @errors << "[案件一覧:#{i + 1}][ポジション] #{branch.errors.full_messages.to_sentence}"  unless branch.valid?
      @branches << branch

    end
    
    return if @errors.present?
    create_logs
  end
  
  private
  
  def get_currency_pair_id str
    if str.include? 'XAU'
      CurrencyPair.find_by
    end
  end
  
  
  def create_logs
    @logs.each do |log|
      next unless log.save
    end
  end
end
