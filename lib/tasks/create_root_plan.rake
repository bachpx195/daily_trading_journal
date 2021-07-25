namespace :db do
  desc "create root plan"

  task create_root_plan: :environment do
    puts "1. create root plan"
    abort("Errors: Root đã tồn tại") if Plan.find_by(title: 'root').present?
    root_plan = Plan.create! title: "root", start_date: Time.zone.now, status: :open, category: :other, content: "This is the root plan"

    root_plan.reload
  end
end
