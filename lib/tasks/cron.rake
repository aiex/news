task :update_news => :environment do
  RssLink.update_news
end