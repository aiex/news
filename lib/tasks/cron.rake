task :update_news => :environment do
  c = Cron.create
  begin
    RssLink.update_news
    c.update_attributes(status: "Finished", finished_at: Time.now)
  rescue Exception => e
    c.update_attributes(status: "Failed", finished_at: Time.now)
  end
end