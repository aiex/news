class RssLink < ActiveRecord::Base
  attr_accessible  :title, :url, :description, :category_id, :home_url ,:list_ids

  serialize :list_ids, Array

  validates :title, :url, :category_id, :home_url, presence: true

  belongs_to :category
  has_many :news_feeds, dependent: :destroy
  after_destroy :remove_references


  class << self
    def update_news
      select("id, url").each do |rss|
        Parser.parse(rss)
      end
    end
  end

  private
  def remove_references
    lists = List.select("id, rss_link_ids").where("id IN (?)", self.list_ids)
    lists.each do |list|
      next list.rss_link_ids.empty?
      # rss_link_ids = list.rss_link_ids.clone.uniq
      # rss_link_ids.delete(self.id)
      # list.update_attribute(:rss_link_ids, rss_link_ids)
      list.rss_link_ids.delete(self.id)
      list.update_attribute(:rss_link_ids, list.rss_link_ids.uniq)
    end
  end
end
