class AddIndices < ActiveRecord::Migration
  def up
    #add_index :news_feeds, :rss_id
    add_index :news_feeds, :published_date
    add_index :news_feeds, [:rss_id, :published_date]
    add_index :rss_links, :category_id
  end

  def down
    remove_index :rss_links, :category_id
    remove_index :news_feeds, [:rss_id, :published_date]
    remove_index :news_feeds, :published_date
    remove_index :news_feeds, :rss_id
  end
end
