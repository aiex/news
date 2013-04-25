require 'sax-machine'
require 'rexml/document'
require 'nokogiri'
require 'open-uri'

# class AtomImage
#   include SAXMachine
#   attribute :url, as: :url
# end

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

class Feed
  include SAXMachine

  # Title
  element :title

  # Author
  element :author, as: :author
  element :"dc:creator" , as: :author
  element :name, as: :author
  element :"im:name", as: :author
  element :"itunes:author", as: :author

  # Description
  element :description, as: :description
  element :summary, as: :description
  element :content, as: :description
  element :"itunes:summary", as: :description

  # link
  element :link, as: :url
  element :"feedburner:origLink", as: :url
  element :link, :value => :href, as: :url, :with => {:type => "text/html"}
  element :link, :value=> :href, as: :url

  # Published date
  element :published, as: :published_date
  element :pubDate, as: :published_date
  element :pubdate, as: :published_date
  element :updated, as: :published_date
  element :issued, as: :published_date
  element :created, as: :published_date
  element :"dc:date", as: :published_date
  element :"dc:Date", as: :published_date
  element :"dcterms:created", as: :published_date

  # Media Description
  element :"media:description", :as => :media_description
  element :"media:credit", :as => :media_credit

  # Categories
  elements :"media:keywords", :as => :categories
  elements :keywords, :as => :categories
  elements :category, :as => :categories
  elements :"itunes:keywords", :as => :categories

  # Entry Id
  element :guid, :as => :entry_id
  element :id, :as=> :entry_id

  # Media content
  element :"media:content", :value=> :url, :as => :media_content #, :class => MediaContent
  element :"media:thumbnail", :value=> :url, :as => :media_content
  element :enclosure, :value=> :url, :as => :media_content #, :with=>{:type=>"image"}
  element :"im:image", :as => :media_content
  element :"itms:coverArt", :as => :media_content
  element :"g:image_link", :as => :media_content
  element :link, :value=> :href, :as => :media_content, :with => {:rel=>"enclosure"}

  # element :enclosure, as: :images, class: AtomImage
  # element :content, as: :image, class: AtomImage
  def media_image
    (@media_content && @media_content =~ /(jpg|jpeg|tiff|png)/i) ? @media_content : nil
  end
end

class Rss
  include SAXMachine

  # Title
  element :title

  # Description
  element :description, as: :description
  element :"itunes:summary", :as => :description
  element :subtitle, :as => :description
  element :description, :as => :description

  # Keywords
  elements :"itunes:keywords", :as => :keywords
  elements :"itunes:category", :as => :keywords, :value => :text
  elements :keywords

  # Image
  element :image, class: FeedImage
  element :"itunes:image", as: :image, class: HrefTag

  # Home page url
  element :link, as: :home_page_url
  element :link, value: :href, as: :home_page_url, :with => {:type => "text/html"}
  element :link, value: :href, as: :home_page_url, :with => {:type => "application/atom+xml"}

  # Feeds
  elements :entry, :as => :feeds, :class => Feed
  elements :item, :as => :feeds, :class => Feed
end