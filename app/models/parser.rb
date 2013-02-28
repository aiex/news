#url = 'http://feeds.feedburner.com/NdtvNews-TopStories'

require 'rexml/document'
require 'nokogiri'
require 'open-uri'

class Parser

  class << self

    def get_rss_info(url)
      content = Net::HTTP.get(URI.parse(url))
      xml = REXML::Document.new(content)
      {
        :title => xml.root.elements['channel/title'].text,
        :home_url => xml.root.elements['channel/link'].text,
        :description => xml.root.elements['channel/description'].text
      }
    end

    def parse(rss)
      puts "Rss URL => #{rss.url} \n\n\nFetching started..."
      content = Net::HTTP.get(URI.parse(rss.url))
      xml = REXML::Document.new(content)

      ######### Parsing Starts
      data = []
      xml.elements.each('//item') do |item|
        puts "*************** #{item.elements['link'].text} *******************"
        feed = {}
        feed[:title] = item.elements['title'].text
        feed[:description] = item.elements['description'].text #.gsub("---\n- ! '", "").gsub("---", "").gsub!(/(<[^>]+>|&nbsp;|\r|\n)/,""),
        feed[:link] = item.elements['link'].text
        feed[:published_date] = if item.elements['dc:date']
          item.elements['dc:date'].text
        elsif item.elements['pubDate']
          item.elements['pubDate'].text
        else
          ''
        end
        keywords = image_urls = []
        item.each_recursive do |childElement|
          keywords << childElement.text if childElement.name == "category"
          if childElement.name == "content" && childElement.attributes["medium"].present?
            image_urls << childElement.attributes["url"]
          elsif childElement.name == "enclosure"
            image_urls << childElement.attributes["url"]
          end
        end
        feed[:keywords] = keywords.join(",")
        feed[:image_urls] = image_urls.join(",")
        data << feed
      end
      ######### Parsing Ends
      data.each do |feed|
        puts feed, feed[:link], "\n\n"
        NewsFeed.create(
          rss_id: rss.id,
          title: feed[:title],
          description: feed[:description],
          link: feed[:link],
          published_date: feed[:published_date],
          keywords: feed[:keywords],
          image_urls: feed[:image_urls]
        )
      end
    end
  end
end

