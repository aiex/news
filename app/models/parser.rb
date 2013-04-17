# url = 'http://feeds.feedburner.com/NdtvNews-TopStories'

# require 'rexml/document'
require 'open-uri'

class Parser

  class << self

    ## Old Parser
    # def get_rss_info(url)
    #   content = Net::HTTP.get(URI.parse(url))
    #   xml = REXML::Document.new(content)
    #   {
    #     :title => xml.root.elements['channel/title'].text,
    #     :home_url => xml.root.elements['channel/link'].text,
    #     :description => xml.root.elements['channel/description'].text
    #   }
    # end

    # def parse(rss)
    #   puts "Rss URL => #{rss.url} \n\n\nFetching started..."
    #   content = Net::HTTP.get(URI.parse(rss.url))
    #   xml = REXML::Document.new(content)

    #   ######### Parsing Starts
    #   data = []
    #   xml.elements.each('//item') do |item|
    #     puts "*************** #{item.elements['link'].text} *******************"
    #     feed = {}
    #     feed[:title] = item.elements['title'].text
    #     feed[:description] = item.elements['description'].text #.gsub("---\n- ! '", "").gsub("---", "").gsub!(/(<[^>]+>|&nbsp;|\r|\n)/,""),
    #     feed[:link] = item.elements['link'].text
    #     feed[:published_date] = if item.elements['dc:date']
    #       item.elements['dc:date'].text
    #     elsif item.elements['pubDate']
    #       item.elements['pubDate'].text
    #     else
    #       ''
    #     end
    #     keywords = image_urls = []
    #     item.each_recursive do |childElement|
    #       keywords << childElement.text if childElement.name == "category"
    #       if childElement.name == "content" && childElement.attributes["medium"].present?
    #         image_urls << childElement.attributes["url"]
    #       elsif childElement.name == "enclosure"
    #         image_urls << childElement.attributes["url"]
    #       end
    #     end
    #     feed[:keywords] = keywords.join(",")
    #     feed[:image_urls] = image_urls.join(",")
    #     data << feed
    #   end
    #   ######### Parsing Ends
    #   data.each do |feed|
    #     puts feed, feed[:link], "\n\n"
    #     NewsFeed.create(
    #       rss_id: rss.id,
    #       title: feed[:title],
    #       description: feed[:description],
    #       link: feed[:link],
    #       published_date: feed[:published_date],
    #       keywords: feed[:keywords],
    #       image_urls: feed[:image_urls]
    #     )
    #   end
    # end

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
      puts "last_published_date", last_published_date
      feeds.feeds.each do |feed|
        pub_date = feed.published_date.to_datetime rescue nil
        next if last_published_date && pub_date && (last_published_date >= feed.published_date)
        NewsFeed.create(
          rss_id: rss.id,
          title: feed.title,
          description: feed.description,
          link: feed.url,
          published_date: pub_date,
          image_urls: (feed.media_image ? [item.media_image] : [])
        )
      end
    end

    def able_to_parse?(xml)
      (/\<rss|\<rdf|\<feed/ =~ xml) || (%r{<id>https?://docs.google.com/.*\</id\>} =~ xml) || (/Atom/ =~ xml) || (/feedburner/ =~ xml) || (/xmlns:itunes=\"http:\/\/www.itunes.com\/dtds\/podcast-1.0.dtd\"/i =~ xml)
    end

  end

end

