class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :name
      t.text :rss_link_ids
      t.integer :user_id
      t.timestamps
    end
  end
end
