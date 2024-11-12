namespace :db do
  desc "create day event"

  task create_day_event: :environment do
    require 'mechanize'
    agent = Mechanize.new
    root_path = "https://vn.investing.com/economic-calendar/cpi-69"
    
    agent.get(root_path)
    glossaries = agent.page.search('.glossaryEntry')
    glossaries.each do |glossary|
      Glossary.create!(title: glossary.search("h2").map(&:text).map(&:strip)[0], brief: glossary.search("div").map(&:text).map(&:strip)[0], content: Mechanize.new.get("#{root_path}#{glossary.attributes['href'].value}").search(".fr-view")[0])
    end
  end
end