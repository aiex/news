# url = 'http://feeds.feedburner.com/NdtvNews-TopStories'

# require 'rexml/document'
require 'open-uri'

class Parser

  class << self

    def get_rss_info(url)
      content = Net::HTTP.get(URI.parse(url))
      feed = Rss.parse(content)
      {
        :title => feed.title,
        :home_url => feed.home_page_url,
        :description => feed.description
      }
    end

    def parse(rss)
      content = Net::HTTP.get(URI.parse(rss.url))
      if able_to_parse?(content)
        feeds = Rss.parse(content)
      else
        begin
          content = open(url).read
          feeds = able_to_parse?(content) ? Rss.parse(content) : []
        rescue Exception => e
          return
        end
      end

      last_published_date = NewsFeed.select("MAX(published_date) AS published_date").where(rss_id: rss.id).last.try(:published_date)
      #puts "last_published_date", last_published_date if Rails.env == 'development'
      feeds.feeds.each do |feed|
        DbLogger.log("PUBLISHED DATE, PD.to_datetime, last_published_date #{feed.published_date} #{(feed.published_date.to_datetime rescue nil)} #{last_published_date}")
        pub_date = feed.published_date.to_datetime rescue nil
        next if last_published_date && pub_date && (last_published_date >= feed.published_date)
        NewsFeed.create(
          rss_id: rss.id,
          title: feed.title,
          description: feed.description,
          link: feed.url,
          published_date: pub_date,
          image_urls: (feed.media_image ? [feed.media_image] : [])
        )
      end
    end

    def able_to_parse?(xml)
      (/\<rss|\<rdf|\<feed/ =~ xml) || (%r{<id>https?://docs.google.com/.*\</id\>} =~ xml) || (/Atom/ =~ xml) || (/feedburner/ =~ xml) || (/xmlns:itunes=\"http:\/\/www.itunes.com\/dtds\/podcast-1.0.dtd\"/i =~ xml)
    end

  end

end

