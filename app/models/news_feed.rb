class NewsFeed < ActiveRecord::Base
  attr_accessible :description, :image_urls, :keywords, :link, :published_date, :rss_id, :title

  before_create :sanitize_fields
  serialize :image_urls, Array

  def sanitize_fields
    self.description = ActionController::Base.helpers.strip_tags(self.description)
  end

  def self.delete_old_news
    delete_count = where("created_at < ?", Time.now - 2.week).count
    total_count = count
    if total_count - delete_count >= 500
      where("created_at < ?", Time.now - 2.week).delete_all
      return true
    else
      return false
    end
  end

end
