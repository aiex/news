class CreateNewsFeeds < ActiveRecord::Migration
  def change
    create_table :news_feeds do |t|
      t.string :title
      t.text :description
      t.string :link
      t.datetime :published_date
      t.string :keywords
      t.string :image_urls
      t.integer :rss_id

      t.timestamps
    end
  end
end
