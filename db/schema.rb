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

ActiveRecord::Schema.define(version: 2019_05_23_060650) do

  create_table "coin_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.bigint "coin_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coin_category_id"], name: "index_coins_on_coin_category_id"
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

  create_table "new_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "new_sites", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "domanin"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "news", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "url"
    t.string "domain"
    t.text "short_description"
    t.string "tilte"
    t.date "published_at"
    t.integer "status"
    t.date "intended_date"
    t.bigint "new_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["new_category_id"], name: "index_news_on_new_category_id"
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
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "coin_links", "coins"
  add_foreign_key "coin_sources", "coins"
  add_foreign_key "coins", "coin_categories"
  add_foreign_key "daily_reports", "coins"
  add_foreign_key "daily_reports", "news", column: "new_id"
  add_foreign_key "news", "new_categories"
  add_foreign_key "news_tags", "news", column: "new_id"
  add_foreign_key "news_tags", "tags"
end
