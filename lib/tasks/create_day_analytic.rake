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
end



