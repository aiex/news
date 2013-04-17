class AdminController < ApplicationController
  def index
  end

  def cron
    @crons = Cron.select("id, status, created_at, finished_at").page(params[:page]).per(20).order("created_at DESC")
  end

  def update_rss
    RssLink.update_news
  end

  def delete_old_news
    @result = NewsFeed.delete_old_news
  end
end
