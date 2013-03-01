class AdminController < ApplicationController
  def index
  end

  def update_rss
    RssLink.update_news
  end

  def delete_old_news
    @result = NewsFeed.delete_old_news
  end
end
