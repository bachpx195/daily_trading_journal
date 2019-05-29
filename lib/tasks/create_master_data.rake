namespace :db do
  desc "remake database data"

  task create_master_data: :environment do
    Rake::Task["db:migrate:reset"].invoke
    group_arr = ['Coin categories', 'News categories', 'Wiki categories', 'Site categories', 'Mark tag']
    
    puts "0. create group"
    group_arr.each do |group|
      Group.create! name: group
    end

    #Coin Category
    puts "1. create coin tag"
    coin_tag = Group.find_by(name: 'Coin categories')
    coin_tag.tags.create! name: 'Currency', slug: 'tiền tệ'
    coin_tag.tags.create! name: 'Platform', slug: 'nền tảng'
    coin_tag.tags.create! name: 'Token', slug: 'Ứng dụng'
    coin_tag.tags.create! name: 'Exchange', slug: 'Sàn'
    coin_tag.tags.create! name: 'Shitcoin/Scam', slug: 'Rác'

    #News Category
    puts "2. create news tag"    
    news_tag = Group.find_by(name: 'News categories')
    news_tag.tags.create! name: 'Fomo', slug: 'Good'
    news_tag.tags.create! name: 'Fud', slug: 'Bad'
    news_tag.tags.create! name: 'Event', slug: 'Sự kiện'
    news_tag.tags.create! name: 'Predict', slug: 'Dự đoán'

    #Wiki Category
    puts "3. create wiki tag"    
    wiki_tag = Group.find_by(name: 'Wiki categories')
    wiki_tag.tags.create! name: 'Concept', slug: 'Khái niệm'

    #Site Category
    puts "4. create site tag"    
    site_tag = Group.find_by(name: 'Site categories')
    site_tag.tags.create! name: 'Formal', slug: 'Chính thức'
    site_tag.tags.create! name: 'Blog', slug: 'Blog'
    site_tag.tags.create! name: 'General', slug: 'Tổng hợp'

    #Mark tag
    puts "4. create mark tag"
    mark_tag = Group.find_by(name: 'Mark tag')
    mark_tag.tags.create! name: 'New rising', slug: 'Mới'
    mark_tag.tags.create! name: 'Hot', slug: 'Nóng'
    mark_tag.tags.create! name: 'Bullish', slug: 'Bò'
    mark_tag.tags.create! name: 'Bearish', slug: 'Gấu'
    mark_tag.tags.create! name: 'Important', slug: 'Quan trọng'
    mark_tag.tags.create! name: 'Saved', slug: 'Đã lưu'
    mark_tag.tags.create! name: 'Lol', slug: 'Hài đcđ'
  end
end
