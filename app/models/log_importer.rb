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
    
    if File.read(csv_file.path).include?("\r\n")
      File.write(csv_file.path,File.open(csv_file.path,&:read).encode("UTF-8").gsub("\r\n",","))
      
      csv_text_array = File.read(csv_file.path).split(',')
      
      CSV.open(csv_file.path, "wb") do |csv|
        column_count = Branch::CSV_COLUMN_NAME.count
        loop_number = (csv_text_array.count / column_count) - 1
        if loop_number > 0
          (0..loop_number).each do |i|
            csv << csv_text_array.slice(column_count*(i), column_count*(i+1))
          end
        end
      end
    end
    
    CSV.foreach(
      csv_file.path,
      headers: true,
      header_converters: lambda { |f| f.strip },
      converters: lambda { |f| f ? f.strip : nil }
    ).with_index do |row, i|
      city = City.find_by(name: row['市区町村*'])
      
      if city.present?
        branch = Branch.new(
          name: row.first.last,
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
      else
        @errors << "[案件一覧:#{i + 1}][ポジション] City's name not found"
      end
    end
    
    return if @errors.present?
    create_branches
  end
  
  private
  
  def create_branches
    @branches.each do |branch|
      next unless branch.save
    end
  end
end
