require 'sax-machine'
require 'rexml/document'
require 'nokogiri'
require 'open-uri'

module RssFeed
  class MediaContent
    include SAXMachine
    attribute :url
    
  end
  
  class HrefTag
    include SAXMachine
    attribute :href, as: :url
  end
    
  class FeedImage
    include SAXMachine
    element :title
    element :url
    element :link
  end

  # Class for parsing an atom entry out of a feedburner atom feed
  class FeedEntry
    include SAXMachine
    
    #Title
    element :title
    
    #Author
    element :author, :as => :author
    element :"dc:creator" , :as => :author
    element :name, :as => :author
    element :"im:name", :as => :author
    element :"itunes:author", :as => :author
    
    # Description
    element :summary, :as => :description
    element :description, :as => :description
    element :content, :as => :description
    element :"itunes:summary", :as => :description
    
    # link
    element :link
    element :"feedburner:origLink", :as => :link
    element :link, :value => :href, :as => :link, :with => {:type => "text/html"}
    element :link, :value=> :href, :as=> :link
    
    # Published date
    element :published, :as => :published
    element :pubDate, :as => :published
    element :pubdate, :as => :published
    element :updated, :as => :published
    element :issued, :as => :published
    element :created, :as => :published
    element :"dc:date", :as => :published
    element :"dc:Date", :as => :published
    element :"dcterms:created", :as => :published
    
    # Media conetent
    element :"media:content", :value=> :url, :as => :media_content#, :class => MediaContent
    element :"media:thumbnail", :value=> :url, :as => :media_content
    element :enclosure, :value=> :url, :as => :media_content#, :with=>{:type=>"image"}
    element :"im:image", :as => :media_content
    element :"itms:coverArt", :as => :media_content
    element :"g:image_link", :as => :media_content
    element :link, :value=> :href, :as => :media_content, :with => {:rel=>"enclosure"}
    
    # Media Description
    element :"media:description", :as => :media_description
    element :"media:credit", :as => :media_credit
    
    elements :"media:keywords", :as => :categories
    elements :keywords, :as => :categories
    elements :category, :as => :categories
    elements :"itunes:keywords", :as => :categories
    
    element :guid, :as => :entry_id
    element :id, :as=> :entry_id
    
    def media_image
      (@media_content && @media_content =~ /(jpg|jpeg|tiff|png)$/i) ? @media_content : nil
    end
  end

  # Class for parsing Atom feeds
  class RssFeed
    include SAXMachine
    
    # Title
    element :title
    
    # Description
    element :"itunes:summary", :as => :description
    element :description, as: "description"
    element :subtitle, :as => :description
    
    # Language
    element :language, as: "lang"
    
    # link
    element :link, :value => :href, :as => :link, :with => {:type => "text/html"}
    element :link, :value => :href, :as => :link, :with => {:type => "application/atom+xml"}
    
    # Keywords
    elements :"itunes:keywords", :as => :keywords
    elements :"itunes:category", :as => :keywords, :value => :text
    elements :keywords
    
    # Entries
    elements :item, :as => :entries, :class => FeedEntry
    elements :entry, :as => :entries, :class => FeedEntry
    
    # Image
    element :image, class: FeedImage
    element :"itunes:image", :as => "image", class: HrefTag
    
    # element :"itunes:image", :value => :href, :as => :image
    
    def self.parse_rss_url(url)
      xml = Net::HTTP.get(URI.parse(url))
      if able_to_parse?(xml)
        parse(xml)
      else
        begin
          xml = open(url).read
          able_to_parse?(xml) ? parse(xml) : nil
        rescue Exception => e
          nil
        end
      end
      # able_to_parse?(xml) ? parse(xml) : nil
    end
    
    def self.able_to_parse?(xml)
      # google
      #%r{<id>https?://docs.google.com/.*\</id\>} =~ xml
      # Atom and feedburner
      # (/Atom/ =~ xml) && (/feedburner/ =~ xml)
      # Itune
      #/xmlns:itunes=\"http:\/\/www.itunes.com\/dtds\/podcast-1.0.dtd\"/i =~ xml
      #Feedburner
      #(/\<rss|\<rdf/ =~ xml) && (/feedburner/ =~ xml)
      (/\<rss|\<rdf|\<feed/ =~ xml) || (%r{<id>https?://docs.google.com/.*\</id\>} =~ xml) || (/Atom/ =~ xml) || (/feedburner/ =~ xml) || (/xmlns:itunes=\"http:\/\/www.itunes.com\/dtds\/podcast-1.0.dtd\"/i =~ xml)
    end
    
  end
end