module ApplicationHelper
  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      Pygments.highlight(code, lexer: language)
    end
  end

  def markdown content
    if content.present?
      renderer = HTMLwithPygments.new(hard_wrap: true, filter_html: true, tables: true)
      options = {
        autolink: true,
        no_intra_emphasis: true,
        disable_indented_code_blocks: true,
        fenced_code_blocks: true,
        lax_html_blocks: true,
        strikethrough: true,
        superscript: true,
        quote: true,
        highlight: true,
        tables: true,
        emoji: true
      }
      Redcarpet::Markdown.new(renderer, options).render(content).html_safe
    end
  end
  
	def total_money logs
		sum = 0
		logs.each do |log|
			sum = sum + log.money.to_i
		end
		sum
	end

  def format_date_ddMMyyyHHmm(str, hour = "")
    if str!=nil
      date_format = '%d/%m/%Y ' + "#{hour}"
      str.strftime(date_format)
    else
      ''
    end
  end

  def format_date_MMyyy str
    if str!=nil
      date_format = '%m/%Y'
      str.strftime(date_format)
    else
      ''
    end
  end

  def format_money(str, has_unit = true)
    if (has_unit)
      if str == 0 || str.nil?
        ''
      else
        number_with_delimiter(str, delimiter: ".", separator: ",")+" VNĐ"
      end
    else
      if str == 0 || str.nil?
        ''
      else
        number_with_delimiter(str, delimiter: ".", separator: ",")
      end
    end
  end

  def format_money_with_fund(str, status = nil)
    if status.present?
      if str == 0 || str.nil?
        ''
      else
        fund_log_change_money(status) + number_with_delimiter(str, delimiter: ".", separator: ",")+" USD"
      end
    else
      number_with_delimiter(str, delimiter: ".", separator: ",")+" USD" if str.present?
    end
  end

  def format_log_status(str)
  	case str
  	when "0"
  		"Hòa vốn"
		when "1"
			"Lãi"
		else
			"Lỗ"
  	end
	end

  def format_fund_log_status(str)
    case str
    when "profit"
      "+ Tiền lãi"
    when "loss"
      "- Tiền lỗ"
    when "deposit"
      "+ Nạp"
    when "withdraw"
      "- Rút"
    when "deposit_fee"
      "- Chuyển vào phí giao dịch"
    when "fee"
      "- Trừ phí"
    else
      "None"
    end
  end
  
  def format_trade_status(str)
    case str
      when "draft"
        "Nháp"
      when "open"
        "Đang giao dịch"
      when "close"
        "Giao dịch đã đóng"
      else
        "None"
    end
  end

  def fund_log_change_money stt
    case stt
    when "profit"
      "+"
    when "deposit"
      "+"
    else
      "-"
    end
  end
  
  def trade_log_result log
    if log.present?
      if log.money + log.fee < 0
        "Lỗ #{(log.money + log.fee).round(2)}Usd"

      else
        "Lãi #{(log.money + log.fee).round(2)}Usd"
      end
    end
  end
  
  def random_color index=nil
    color_arr = %w[ green blue purple red yellow dark blue-madison blue-chambray blue-ebonyclay blue-hoki blue-steel blue-soft blue-dark blue-sharp  green-meadow green-seagreen green-turquoise green-haze green-jungle
                    green-soft green-dark green-sharp red-pink red-sunglo red-intense red-thunderbird red-flamingo red-soft red-haze red-mint yellow-gold yellow-casablanca yellow-crusta yellow-lemon yellow-saffron
                    yellow-soft yellow-haze yellow-mint purple-plum purple-medium purple-studio purple-wisteria purple-seance purple-intense purple-sharp purple-soft default]
    if index.present?
      color_arr[index.to_i]
    else
      color_arr.sample
    end
  end
  
  # def label_tag tag_name
  #   case tag_name
  #     when
  #   end
  #   data = ''
  #   case id

  #   end
  #   data.html_safe
  # end
  
  # def tag_icon id
  #   # data = ''
  #   # case id
  #   #
  #   # end
  #   # data.html_safe
  # end
end





