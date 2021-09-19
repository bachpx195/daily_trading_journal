namespace :db do
  desc "create root plan"

  task create_plan_by_date: :environment do
    MONTHS = [1,2,3,4,5,6,7,8,9,10,11,12]
    plan_tag = Tag.find_by(title: "plan_tag")
    year_tag = Tag.find_by(title: "plan_year")
    month_tag = Tag.find_by(title: "plan_month")
    week_tag = Tag.find_by(title: "plan_week")
    day_tag = Tag.find_by(title: "plan_day")
    current_year = Time.now.year
    beginning_of_year = Time.new(current_year, 1, 1, 0,0,0, "+07:00").beginning_of_month
    end_of_year = Time.new(current_year, 12, 31,23,59,59, "+07:00").end_of_month
    first_week_of_year = beginning_of_year.monday? ? beginning_of_year : beginning_of_year.next_week
    first_number_week = Time.new(current_year, 1, 1, 0,0,0, "+07:00").strftime("%U").to_i
    last_number_week = Time.new(current_year, 12, 31,23,59,59, "+07:00").strftime("%U").to_i
    week_arr = {}
    (first_number_week..last_number_week).each do |num|
      week_arr[num] = {start_date: (first_week_of_year + num*7.days).beginning_of_day, end_date: (first_week_of_year + num*7.days + 6.days).end_of_day}
    end

    puts "1. create root plan"
    root_plan = Plan.find_by(title: 'root')
    unless root_plan.present?
      root_plan = Plan.create! title: "root", start_date: Time.zone.now, status: :open, category: :other, content: "This is the root plan", tag_id: plan_tag.id
    end

    puts "2. create year plan"
    year_plan = Plan.where(tag_id: year_tag.id, start_date: beginning_of_year, end_date: end_of_year).first
    unless year_plan.present?
      year_plan = Plan.create! title: "Kế hoạch giao dịch năm #{current_year}", start_date: beginning_of_year, end_date: end_of_year, status: :open, tag_id: year_tag.id
    end

    puts "3. create month plan"
    MONTHS.each do |month|
      beginning_of_month = Time.new(current_year, month,1,0,0,0, "+07:00").beginning_of_month
      end_of_month = Time.new(current_year, month).end_of_month
      month_plan = Plan.where(tag_id: month_tag.id, start_date: beginning_of_month, end_date: end_of_month).first
      unless month_plan.present?
        month_plan = Plan.create! title: "Kế hoạch giao dịch tháng #{month}/#{current_year}", start_date: beginning_of_month, end_date: end_of_month, status: :open, tag_id: month_tag.id
      end
      first_week_of_month = beginning_of_month.monday? ? beginning_of_month : beginning_of_month.next_week
      first_number_week_month = first_week_of_month.strftime("%U").to_i - 1
      last_number_week_month = end_of_month.strftime("%U").to_i - 1
      (first_number_week_month..last_number_week_month).each do |num|
        week_plan = Plan.where(tag_id: week_tag.id, start_date: week_arr[num][:start_date], end_date: week_arr[num][:end_date]).first

        unless week_plan.present?
          week_plan = Plan.create! title: "Kế hoạch giao dịch tuần #{num}",  start_date: week_arr[num][:start_date], end_date: week_arr[num][:end_date], status: :open, tag_id: week_tag.id
          (0..6).each do |day_num|
            day_plan = Plan.where(tag_id: day_tag.id, start_date: (week_arr[num][:start_date]+ day_num.days).beginning_of_day, end_date: (week_arr[num][:start_date]+ day_num.days).end_of_day).first
            unless day_plan.present?
              day_plan = Plan.create! title: "Kế hoạch giao dịch ngày #{week_arr[num][:start_date]+ day_num.days}", start_date: (week_arr[num][:start_date]+ day_num.days).beginning_of_day, end_date: (week_arr[num][:start_date]+ day_num.days).end_of_day, status: :open, tag_id: day_tag.id
              day_plan.move_to_child_of(week_plan)
            end
          end
          week_plan.reload
          week_plan.move_to_child_of(month_plan)
        end
      end
      month_plan.reload
      month_plan.move_to_child_of(year_plan)
    end

    year_plan.reload
    year_plan.move_to_child_of(root_plan)
    root_plan.reload
  end
end
