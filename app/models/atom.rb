require 'sax-machine'

class AtomImage
  include SAXMachine
  attribute :url, as: :url
end

class AtomEntry
  include SAXMachine
  element :title
  element :name, :as => :author
  element :description
  element "feedburner:origLink", as: :url
  element :link, as: :url
  element "dc:date", as: :published_date
  element :pubDate, as: :published_date
  element :enclosure, as: :images, class: AtomImage
  element :content, as: :image, class: AtomImage
end

class Atom
  include SAXMachine
  element :title
  # the :with argument means that you only match a link tag that has an attribute of :type => "text/html"
  # the :value argument means that instead of setting the value to the text between the tag,
  # it sets it to the attribute value of :href
  # element :link, value: :href, :with => {:type => "text/html"}
  element :link, :as => :home_page_url #, :with => {:type => "text/html"}
  element :description, :as => :description
  elements :item, :as => :items, :class => AtomEntry
end

