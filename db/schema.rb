# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130417111031) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "crons", :force => true do |t|
    t.string   "status",      :default => "Started"
    t.datetime "finished_at"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "lists", :force => true do |t|
    t.string   "name"
    t.text     "rss_link_ids"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "news_feeds", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "link"
    t.datetime "published_date"
    t.string   "keywords"
    t.string   "image_urls"
    t.integer  "rss_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "news_feeds", ["published_date"], :name => "index_news_feeds_on_published_date"
  add_index "news_feeds", ["rss_id", "published_date"], :name => "index_news_feeds_on_rss_id_and_published_date"

  create_table "rss_links", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.text     "description"
    t.integer  "category_id"
    t.string   "home_url"
    t.text     "list_ids"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "rss_links", ["category_id"], :name => "index_rss_links_on_category_id"

end
