namespace :db do
  desc "create day analytic"

  task create_day_analytic: :environment do
    puts "1. create day analytic"
    Candlestick.where(merchandise_rate_id: 35).day.each do |c|
      return_oc = ((c.close - c.open)/c.open).round(4)*100
      range_type = if return_oc > 4
        0
      elsif return_oc <= 4 && return_oc > 0.9
        1
      elsif return_oc <= 0.9 && return_oc >= -0.9
        2
      elsif return_oc < -0.9 && return_oc >= -4
        3
      else
        4
      end
      
      DayAnalytic.create!({
        candlestick_id: c.id,
        date: c.date.to_date,
        date_name: c.date.strftime("%A"),
        return_oc: return_oc,
        return_hl: ((c.high - c.low)/c.low).round(4)*100,
        candlestick_type: c.open > c.close ? 0 : 1,
        range_type: range_type
      })
    end
  end

  desc "update_is_inside_day"

  task update_is_inside_day: :environment do
    puts "2. update_is_inside_day"
    Candlestick.where(merchandise_rate_id: 35).day.each do |c|
      day_yesterday = c.previous_day

      next unless day_yesterday.present?

      is_inside_day = day_yesterday.high > c.high && c.low > day_yesterday.low

      DayAnalytic.find_by(candlestick_id: c.id).update(is_inside_day: is_inside_day)
    end
  end

  desc "update_is_same_btc"

  task update_is_same_btc: :environment do
    puts "3. update_is_same_btc"
    Candlestick.where(merchandise_rate_id: 35).day.each do |c|
      btc_day = Candlestick.where(merchandise_rate_id: 34, date: c.date).day.first

      next unless btc_day.present?

      is_same_btc = (btc_day.open - btc_day.close)*(c.open - c.close) > 0

      DayAnalytic.find_by(candlestick_id: c.id).update(is_same_btc: is_same_btc)
      puts c.date
    end
  end

  desc "update_continue_type"

  task update_continue_type: :environment do
    puts "4. update_continue_type"
    count = 1
    Candlestick.where(merchandise_rate_id: 35).day.order(:date).each do |c|
      day_yesterday = c.previous_day

      next unless day_yesterday.present?

      count = if (day_yesterday.open - day_yesterday.close)*(c.open - c.close) > 0
        count + 1
      else
        1
      end

      DayAnalytic.find_by(candlestick_id: c.id).update(continue_type: count)
      puts c.date
      puts count
    end
  end
end



