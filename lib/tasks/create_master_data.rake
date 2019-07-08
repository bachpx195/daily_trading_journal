namespace :db do
  desc "remake database data"

  task create_master_data: :environment do
    Rake::Task["db:migrate:reset"].invoke


    puts "1. create root tag"
    root_tag = Tag.create! title: "root_tag"
    coin = Tag.create! title: 'Coin categories', slug: 'Tags về coin'
    news = Tag.create! title: 'News categories', slug: 'Tags về tin tức'
    wiki = Tag.create! title: 'Wiki categories', slug: 'Tags về wiki'
    site = Tag.create! title: 'Site categories', slug: 'Tags về website'
    mark = Tag.create! title: 'Mark tags', slug: 'Tags khác'

    puts "2. create coin category tag"
    currency = Tag.create! title: 'Currency', slug: 'tiền tệ'
    platform = Tag.create! title: 'Platform', slug: 'nền tảng'
    token = Tag.create! title: 'Token', slug: 'Ứng dụng'
    exchange = Tag.create! title: 'Exchange', slug: 'Sàn'
    shitcoin = Tag.create! title: 'Shitcoin/Scam', slug: 'Rác'
    
    currency.move_to_child_of(coin)
    platform.move_to_child_of(coin)
    token.move_to_child_of(coin)
    exchange.move_to_child_of(coin)
    shitcoin.move_to_child_of(coin)
    coin.reload
    
    puts "3. create news category tag"
    fomo = Tag.create! title: 'Fomo', slug: 'Good'
    fud = Tag.create! title: 'Fud', slug: 'Bad'
    event = Tag.create! title: 'Event', slug: 'Sự kiện'
    predict = Tag.create! title: 'Predict', slug: 'Dự đoán'

    fomo.move_to_child_of(news)
    fud.move_to_child_of(news)
    event.move_to_child_of(news)
    predict.move_to_child_of(news)
    
    news.reload

    puts "4. create wiki category tag"
    concept = Tag.create! title: 'Concept', slug: 'Khái niệm'
    til = Tag.create! title: 'TIL', slug: 'Today i leared'
    ptkt = Tag.create! title: 'PTKT', slug: 'Phân tích kĩ thuật'
    
    price_action = Tag.create! title: 'Price Action', slug: 'Đường giá'
    fibbo = Tag.create! title: 'fibbo', slug: 'Fibbonance'
    ema = Tag.create! title: 'EMA', slug: 'Đường trung bình'

    price_action.move_to_child_of(ptkt)
    fibbo.move_to_child_of(ptkt)
    ema.move_to_child_of(ptkt)
    ptkt.reload
    
    concept.move_to_child_of(wiki)
    til.move_to_child_of(wiki)
    ptkt.move_to_child_of(wiki)
    wiki.reload

    puts "5. create site category tag"
    formal = Tag.create! title: 'Formal', slug: 'Chính thức'
    blog = Tag.create! title: 'Blog', slug: 'Blog'
    general = Tag.create! title: 'General', slug: 'Tổng hợp'

    formal.move_to_child_of(site)
    blog.move_to_child_of(site)
    general.move_to_child_of(site)
    
    site.reload
    
    puts "6. create mark tag"
    new =  Tag.create! title: 'New rising', slug: 'Mới'
    hot = Tag.create! title: 'Hot', slug: 'Nóng'
    bullish = Tag.create! title: 'Bullish', slug: 'Bò'
    bearish = Tag.create! title: 'Bearish', slug: 'Gấu'
    important = Tag.create! title: 'Important', slug: 'Quan trọng'
    saved = Tag.create! title: 'Saved', slug: 'Đã lưu'
    lol = Tag.create! title: 'Lol', slug: 'Hài đcđ'

    new.move_to_child_of(mark)
    hot.move_to_child_of(mark)
    bullish.move_to_child_of(mark)
    bearish.move_to_child_of(mark)
    important.move_to_child_of(mark)
    saved.move_to_child_of(mark)
    lol.move_to_child_of(mark)
    
    mark.reload
    
    coin.move_to_child_of(root_tag)
    news.move_to_child_of(root_tag)
    wiki.move_to_child_of(root_tag)
    site.move_to_child_of(root_tag)
    mark.move_to_child_of(root_tag)

    root_tag.reload


    # group_arr = ['Coin categories', 'News categories', 'Wiki categories', 'Site categories', 'Mark tag']
    #
    # puts "0. create group"
    # group_arr.each do |group|
    #   Group.create! name: group
    # end
    #
    # #Coin Category
    # puts "1. create coin tag"
    # coin_tag = Group.find_by(name: 'Coin categories')
    # coin_tag.tags.create! name: 'Currency', slug: 'tiền tệ'
    # coin_tag.tags.create! name: 'Platform', slug: 'nền tảng'
    # coin_tag.tags.create! name: 'Token', slug: 'Ứng dụng'
    # coin_tag.tags.create! name: 'Exchange', slug: 'Sàn'
    # coin_tag.tags.create! name: 'Shitcoin/Scam', slug: 'Rác'
    #
    # #News Category
    # puts "2. create news tag"
    # news_tag = Group.find_by(name: 'News categories')
    # news_tag.tags.create! name: 'Fomo', slug: 'Good'
    # news_tag.tags.create! name: 'Fud', slug: 'Bad'
    # news_tag.tags.create! name: 'Event', slug: 'Sự kiện'
    # news_tag.tags.create! name: 'Predict', slug: 'Dự đoán'
    #
    # #Wiki Category
    # puts "3. create wiki tag"
    # wiki_tag = Group.find_by(name: 'Wiki categories')
    # wiki_tag.tags.create! name: 'Concept', slug: 'Khái niệm'
    #
    # #Site Category
    # puts "4. create site tag"
    # site_tag = Group.find_by(name: 'Site categories')
    # site_tag.tags.create! name: 'Formal', slug: 'Chính thức'
    # site_tag.tags.create! name: 'Blog', slug: 'Blog'
    # site_tag.tags.create! name: 'General', slug: 'Tổng hợp'
    #
    # #Mark tag
    # puts "5. create mark tag"
    # mark_tag = Group.find_by(name: 'Mark tag')
    # mark_tag.tags.create! name: 'New rising', slug: 'Mới'
    # mark_tag.tags.create! name: 'Hot', slug: 'Nóng'
    # mark_tag.tags.create! name: 'Bullish', slug: 'Bò'
    # mark_tag.tags.create! name: 'Bearish', slug: 'Gấu'
    # mark_tag.tags.create! name: 'Important', slug: 'Quan trọng'
    # mark_tag.tags.create! name: 'Saved', slug: 'Đã lưu'
    # mark_tag.tags.create! name: 'Lol', slug: 'Hài đcđ'

    puts "1. create trade method"
    TradeMethod.create! name: "Thường", win_rate: 0
    TradeMethod.create! name: "Kim tự tháp", win_rate: 0

    puts "2. create coin"
    Tag.find_by(title: "Currency").coins.create! slug: "BTC"
  end
end
