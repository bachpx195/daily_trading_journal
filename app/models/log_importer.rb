# frozen_string_literal: true

require 'csv'
require 'mechanize'

class LogImporter
  attr_reader :files, :csv_file, :logs, :errors

  def initialize(files)
    @files = files
    @errors = []
    @logs = []
  end

  def execute
    # @csv_file = if files.instance_of?(Array)
    #               files.find { |f| File.extname(f.original_filename).casecmp('.csv').zero? }
    #             elsif files.instance_of?(ActionController::Parameters)
    #               files.values.find { |f| File.extname(f.original_filename).casecmp('.csv').zero? }
    #             else
    #               files
    #             end

    # return if @csv_file.blank?

    @html_file = if files.instance_of?(Array)
                  files.find { |f| File.extname(f.original_filename).casecmp('.html').zero? }
                elsif files.instance_of?(ActionController::Parameters)
                  files.values.find { |f| File.extname(f.original_filename).casecmp('.html').zero? }
                else
                  files
                end

    return if @html_file.blank?

    agent = Mechanize.new
    page = agent.get("file:///#{files.path}")

    logs = agent.page.search('tr')
    logs.each_with_index do |log, i|
      row = log.search('td').map(&:text).map(&:strip)
      if row.count == 14 && !Log.find_by(server_code: row[0]).present? && row[0] != "Ticket"
        trade = Trade.new(
          start_date: get_datetime_server(row[1]),
          order_type: get_order_type(row[2]),
          merchandise_rate_id: get_merchandise_rate_id(row[4]),
          end_date: get_datetime_server(row[8]),
          status: 2,
          trade_normal_method_attributes: {point_entry: row[5].to_f,
            point_out: row[6].to_f,
            stop_loss: row[7].to_f,
            take_profit: row[8].to_f,
            amount: row[3]},
          log_attributes: { server_code: row[0],
            status: get_log_status(row[13], row[10], row[12]),
            fee: row[10].to_f + row[12].to_f,
            money: row[13].to_f,
            datetime: Time.zone.now}
        )
        @logs << trade
        @errors << "[Lỗi:#{i + 1}] #{trade.errors.full_messages.to_sentence}"  unless trade.valid?
      end
    end

    # CSV.foreach(
    #   csv_file.path,
    #   headers: true,
    #   header_converters: lambda { |f| f.strip },
    #   converters: lambda { |f| f ? f.strip : nil }
    # ).with_index do |row, i|
    #   unless Log.find_by(server_code: row[0]).present?
    #     trade = Trade.new(
    #       merchandise_rate_id: get_merchandise_rate_id(row[1]),
    #       start_date: get_datetime_server(row[3]),
    #       end_date: get_datetime_server(row[5]),
    #       order_type: get_order_type(row[2]),
    #       status: 2,
    #       trade_normal_method_attributes: {point_entry: row[4].to_f, point_out: row[6].to_f},
    #       log_attributes: { server_code: row[0],
    #        status: get_log_status(row[7], row[8], row[9]),
    #        fee: row[8].to_f + row[9].to_f,
    #        money: row[7].to_f,
    #        datetime: Time.zone.now}
    #     )
    #     @logs << trade
    #     @errors << "[Lỗi:#{i + 1}] #{trade.errors.full_messages.to_sentence}"  unless trade.valid?
    #   end
    # end

    return if @errors.present?
    create_logs
  end

  private

  def get_log_status str, fee, swap
    if str.to_f <= 5 || str.to_f >= -5
      0
    elsif str.to_f > 5
      1
    else
      2
    end
  end

  def get_order_type str
    if str == 'sell'
      0
    else
      1
    end
  end

  def get_datetime_server str
    return unless str.present?
    DateTime.strptime("#{str} +0", '%Y.%m.%d %H:%M:%S %z')
  end

  def get_merchandise_rate_id str
    # if str.include? 'xau'
    #   return MerchandiseRate.find_by(slug: 'XAU/USD').id
    # end
    # symbol_arr = []
    # Merchandise.pluck(:slug).each do |symbol|
    #   symbol_arr << symbol if str.include? symbol.downcase
    # end
    #
    # symbol_pair = symbol_arr.join('/')
    # symbol_pair_reverse = symbol_arr&.reverse.join('/')
    #
    # currency = nil
    #
    # if symbol_pair.present?
    #   currency = MerchandiseRate.find_by(slug: symbol_pair) || MerchandiseRate.find_by(slug: symbol_pair_reverse)
    # end
    #
    # currency.id
    #
    MerchandiseRate.first.id
  end

  def create_logs
    @logs.each do |log|
      next unless log.save
    end
  end
end
