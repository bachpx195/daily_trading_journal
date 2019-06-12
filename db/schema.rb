# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_06_12_023722) do

  create_table "ckeditor_assets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "coin_links", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "url"
    t.string "kind"
    t.bigint "coin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coin_id"], name: "index_coin_links_on_coin_id"
  end

  create_table "coin_sources", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "domain_slug"
    t.string "website"
    t.bigint "coin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coin_id"], name: "index_coin_sources_on_coin_id"
  end

  create_table "coins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.text "description"
    t.string "code"
    t.integer "rank"
    t.string "meta_title"
    t.float "market_cap_usd"
    t.float "price_usd"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_coins_on_tag_id"
  end

  create_table "comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "content"
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_id"], name: "index_comments_on_commentable_id"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["commentable_type"], name: "index_comments_on_commentable_type"
  end

  create_table "daily_reports", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "date"
    t.bigint "coin_id"
    t.bigint "new_id"
    t.string "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coin_id"], name: "index_daily_reports_on_coin_id"
    t.index ["new_id"], name: "index_daily_reports_on_new_id"
  end

  create_table "funds", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.float "initial_capital"
    t.float "present_value"
    t.float "future_value"
    t.float "desposit"
    t.float "withdraw"
    t.float "rate_of_growth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "status"
    t.float "result"
    t.text "note"
    t.float "money"
    t.datetime "datetime"
    t.integer "period_time"
    t.integer "rating"
    t.bigint "trade_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trade_id"], name: "index_logs_on_trade_id"
  end

  create_table "news", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "url"
    t.string "domain"
    t.text "short_description"
    t.string "tilte"
    t.date "published_at"
    t.integer "status"
    t.date "intended_date"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_news_on_tag_id"
  end

  create_table "news_sites", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "domain"
    t.text "description"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_news_sites_on_tag_id"
  end

  create_table "news_tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "new_id"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["new_id"], name: "index_news_tags_on_new_id"
    t.index ["tag_id"], name: "index_news_tags_on_tag_id"
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_tags_groups_on_group_id"
    t.index ["tag_id"], name: "index_tags_groups_on_tag_id"
  end

  create_table "trade_methods", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.float "win_rate"
    t.text "rule"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trade_normal_methods", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "trade_method_id"
    t.bigint "trade_id"
    t.float "point_entry"
    t.float "point_out"
    t.float "stop_loss"
    t.float "take_profit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trade_id"], name: "index_trade_normal_methods_on_trade_id"
    t.index ["trade_method_id"], name: "index_trade_normal_methods_on_trade_method_id"
  end

  create_table "trade_pyramid_methods", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "trade_method_id"
    t.bigint "trade_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trade_id"], name: "index_trade_pyramid_methods_on_trade_id"
    t.index ["trade_method_id"], name: "index_trade_pyramid_methods_on_trade_method_id"
  end

  create_table "trades", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "coin_id"
    t.integer "status"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coin_id"], name: "index_trades_on_coin_id"
  end

  create_table "wikis", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "brief"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_wikis_on_tag_id"
  end

  add_foreign_key "coin_links", "coins"
  add_foreign_key "coin_sources", "coins"
  add_foreign_key "coins", "tags"
  add_foreign_key "daily_reports", "coins"
  add_foreign_key "daily_reports", "news", column: "new_id"
  add_foreign_key "logs", "trades"
  add_foreign_key "news", "tags"
  add_foreign_key "news_sites", "tags"
  add_foreign_key "news_tags", "news", column: "new_id"
  add_foreign_key "news_tags", "tags"
  add_foreign_key "tags_groups", "groups"
  add_foreign_key "tags_groups", "tags"
  add_foreign_key "trade_normal_methods", "trade_methods"
  add_foreign_key "trade_normal_methods", "trades"
  add_foreign_key "trade_pyramid_methods", "trade_methods"
  add_foreign_key "trade_pyramid_methods", "trades"
  add_foreign_key "trades", "coins"
  add_foreign_key "wikis", "tags"
end
