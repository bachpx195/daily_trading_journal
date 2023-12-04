namespace :db do
  desc "create hour analytic"

  task create_hour_analytic: :environment do
    puts "1. create hour analytic"
    Candlestick.where(merchandise_rate_id: 35).hour.each do |c|
      return_oc = ((c.close - c.open)/c.open).round(4)*100
      # range_type = if return_oc > 4
      #   0
      # elsif return_oc <= 4 && return_oc > 0.9
      #   1
      # elsif return_oc <= 0.9 && return_oc >= -0.9
      #   2
      # elsif return_oc < -0.9 && return_oc >= -4
      #   3
      # else
      #   4
      # end

      hour = c.date.strftime("%H").to_i

      puts c.date.to_date
      
      HourAnalytic.create!({
        candlestick_id: c.id,
        date: c.date.to_date,
        date_with_binane: hour < 7 ? c.date.to_date - 1.days : c.date.to_date,
        hour: hour,
        return_oc: return_oc,
        return_hl: ((c.high - c.low)/c.low).round(4)*100,
        candlestick_type: c.open > c.close ? 0 : 1,
      })
    end
  end

  desc "update_range_type"

  task update_range_type: :environment do
    puts "2. update_range_type"
    Candlestick.where(merchandise_rate_id: 35).hour.each do |c|
      return_oc = ((c.close - c.open)/c.open).round(4)*100
      range_type = if return_oc > 1
        0
      elsif return_oc <= 1 && return_oc > 0.3
        1
      elsif return_oc <= 0.3 && return_oc >= -0.3
        2
      elsif return_oc < -0.3 && return_oc >= -1
        3
      else
        4
      end

      puts c.date
      HourAnalytic.find_by(candlestick_id: c.id).update(range_type: range_type)
    end
  end

  desc "update_is_highest_hour_return"
  task is_highest_hour_return: :environment do
    puts "3. update_is_highest_hour_return"

    HourAnalytic.all.each do |ha|
      puts ha.date
      ha.update(is_highest_hour_return: ha.is_highest_hour_return_inday?)
    end
  end

  desc "update_is_reverse_increase_hour"
  task is_reverse_increase_hour: :environment do
    puts "3. update_is_reverse_increase_hour"

    HourAnalytic.group(:date_with_binane).pluck("date_with_binane, count(date_with_binane)").select {|x| x[1] == 24}.each do |ha|
      puts ha[0]

      HourAnalytic.where(date_with_binane: ha[0], hour: HourAnalytic.get_reverse_increase_hour(ha[0])).update(is_reverse_increase_hour: true)
    end
  end

  desc "update_is_reverse_decrease_hour"
  task is_reverse_decrease_hour: :environment do
    puts "4. update_is_reverse_decrease_hour"

    HourAnalytic.group(:date_with_binane).pluck("date_with_binane, count(date_with_binane)").select {|x| x[1] == 24}.each do |ha|
      puts ha[0]

      HourAnalytic.where(date_with_binane: ha[0], hour: HourAnalytic.get_reverse_decrease_hour(ha[0])).update(is_reverse_decrease_hour: true)
    end
  end


  desc "update_is_same_btc"

  task update_is_same_btc: :environment do
    puts "3. update_is_same_btc"
    Candlestick.where(merchandise_rate_id: 35).hour.each do |c|
      btc_hour = Candlestick.where(merchandise_rate_id: 34, date: c.date).hour.first

      next unless btc_hour.present?

      is_same_btc = (btc_hour.open - btc_hour.close)*(c.open - c.close) > 0

      HourAnalytic.find_by(candlestick_id: c.id).update(is_same_btc: is_same_btc)
      puts c.date
    end
  end

  desc "update_continue_by_hour"
  task update_continue_by_hour: :environment do
    puts "4. update_continue_by_hour"
    count = 1
    Candlestick.where(merchandise_rate_id: 35).hour.order(:date).each do |c|
      previous_hour = c.previous_hour

      next unless previous_hour.present?

      count = if (previous_hour.open - previous_hour.close)*(c.open - c.close) > 0
        count + 1
      else
        1
      end

      HourAnalytic.find_by(candlestick_id: c.id).update(continue_by_hour: count)
      puts c.date
      puts count
    end
  end

  desc "update_continue_by_day"
  task update_continue_by_day: :environment do
    puts "4. update_continue_by_day"
    count = 1

    HourAnalytic.order(:date, :hour).all.each do |ha|
      previous_hour_type = ha.get_previous_day_type

      next unless previous_hour_type.present?

      count = if ha.candlestick_type == previous_hour_type
        count + 1
      else
        1
      end

      ha.update(continue_by_day: count)
      puts ha.date
      puts count
    end
  end
end



