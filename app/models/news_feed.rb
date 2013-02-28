class NewsFeed < ActiveRecord::Base
  attr_accessible :description, :image_urls, :keywords, :link, :published_date, :rss_id, :title

  before_create :sanitize_fields

  def sanitize_fields
    self.description = ActionController::Base.helpers.strip_tags(self.description)
  end
end
