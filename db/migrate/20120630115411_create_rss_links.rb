class CreateRssLinks < ActiveRecord::Migration
  def change
    create_table :rss_links do |t|
      t.string :title
      t.string :url
      t.text :description
      t.integer :category_id
      t.string :home_url
      t.text :list_ids
      t.timestamps
    end
  end
end
