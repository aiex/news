require 'rexml/document'
require 'nokogiri'
require 'open-uri'

class Parser

  class << self

    def parse(rss)
      url = rss.url
      # content = Net::HTTP.get(URI.parse(url))
      # xml = REXML::Document.new(content)
      # get_root_data(xml, url)
      # xml.elements.each('//item') do |raw_item|
      #   item = create_node_hash(raw_item)
      #   @data[:items] << get_values(item, raw_item)
      # end
      # save_items(rss.id)
      
      parse_by_rss_feed(url,rss.id)
      
    end
    
    # Move activity creation to Feed callback
    def parse_by_rss_feed(url,rss_link_id)
      feeds = RssFeed::RssFeed.parse_rss_url(url)
      feeds.entries.each do |item|
        params = {
          :title => item.title,
          :description => ActionController::Base.helpers.strip_tags(item.description),
          :link => item.link,
          :author => item.author,
          :publication_date =>  item.published,
          :media_contents => (item.media_image  ? [{:url => item.media_image}] : []),
          :media_description => item.media_description,
          :media_credit => item.media_credit,
          :keywords => (item.categories.present? ? item.categories.join(",") : ""),
          :rss_link_id => rss_link_id
        }
        f = Feed.new(params)
        if f.save
          activity = Activity.new({:action => "Create", :parent_id => rss_link_id, :parent_type => "RssLink", :data => params}) 
          activity.save
          puts "*" * 50
          puts "Title: " + f.title + " parsed and saved"
        end
      end if feeds && feeds.entries
    end

    # TODO: Search for language and country for Rss Link
    def save_items(rss_id)
      feed_publication_date = Feed.where("rss_link_id = ?", rss_id).maximum(:publication_date)
      @data[:items].each do |item|
        puts "^" * 50
        puts item[:publication_date]
        puts Time.parse(item[:publication_date])
        # if feed_publication_date.present? ? (Time.parse(item[:publication_date]) > feed_publication_date) : true
          params = {
            :title => item[:title],
            :description => ActionController::Base.helpers.strip_tags(item[:description]),
            :link => item[:link],
            :author => item[:author],
            :publication_date =>  item[:publication_date],
            :media_contents => item[:media_contents],
            :media_description => item[:media_description],
            :media_credit => item[:media_credit],
            :keywords => item[:keywords].join(","),
            :rss_link_id => rss_id
          }
          f = Feed.new(params)
          if f.save
            activity = Activity.new({:action => "Create", :parent_id => rss_id, :parent_type => "RssLink", :data => params}) 
            activity.save
            puts "*" * 50
            #puts "Title: " + item[:title]
            #puts "Description: " + item[:description]
            #puts "Link: " + item[:link]
            puts "dc:creator: " + item[:author] if item[:author]
            #puts "pubDate: " + item[:publication_date]
            puts "media:content : " + item[:media_contents].inspect if item[:media_contents] 
            puts "media:description : " + item[:media_description] if item[:media_description]
            puts "media:credit : " + item[:media_credit] if item[:media_credit]
            puts "keywords : " + item[:keywords].inspect if item[:keywords]
          end
        # end
      end
    end

    def get_preview_content(url)
      doc = Nokogiri::HTML(open(url))
      domain = url.split('/')[0..2].join('/')
      domain +='/' if domain[-1]!='/'
      content = {}
      content[:title] = doc.search("title").children.text if doc.search("title").present?
      content[:title] = doc.search("meta[property='og:title']").attribute("content").value if content[:title].blank? && doc.search("meta[property='og:title']").present?
      description = doc.search("meta[name='description'], meta[property='og:description']")
      content[:description] = ActionController::Base.helpers.strip_tags(description.first.attribute("content").value) if description.present?
      content[:images] = get_images(doc, domain)
      content
    end

    def get_images(doc, domain)
      images = []
      images_hash = {}
      begin
        
        doc.css("img").select{|img| img[:width].to_i > 50 || img[:height].to_i > 50}.each do |i|
            img_url = i.attribute("src").present? ? i.attribute("src").value : ( i.attribute("imgpath").value if i.attribute("imgpath").present?)
            if img_url
              ext = img_url.split(".").last
              url = img_url.index(/\b(?:https?:\/\/)\S+\b/).nil? ? domain + (img_url[0]=="/" ? img_url[1..-1] : img_url) : img_url
              images << url  unless ext == "gif"
              images_hash[url] = (i[:height].to_i>i[:width].to_i ? i[:height].to_i : i[:width].to_i)  if ext && ext =~ /(jpg|jpeg|tiff|png|cms)$/i
            end
        end
      rescue Exception => e
        puts "****Error message*********"
        puts e
      end
      images_hash.sort_by{|url, size| size}.reverse.map{|e| e[0]}
      # images
    end

  private

  def get_root_data(xml, url)
    @data = {
      :title => xml.root.elements['channel/title'].text,
      :home_url => xml.root.elements['channel/link'].text,
      :rss_url => url,
      :items => [],
      :publication_date => "",
      :media_description => "",
      :media_credit => "",
      :author => ""
    }
  end

  def create_node_hash(raw_item)
    {
      :title => raw_item.elements['title'].text,
      :link => raw_item.elements['link'].text,
      :description => raw_item.elements['description'].text,
      :keywords => [],
      :media_contents => [],
      :author => "",
      :media_description => "",
      :media_credit => ""
    }
  end

  def get_values(item, raw_item)
    item[:media_description] = raw_item.elements['media:description'].text if raw_item.elements['media:description'].present?
    item[:media_credit] = raw_item.elements['media:credit'].text if raw_item.elements['media:credit'].present?
    item[:author] = raw_item.elements['dc:creator'].text if raw_item.elements['dc:creator'].present?
    if raw_item.elements['dc:date']
      item[:publication_date] = raw_item.elements['dc:date'].text
    elsif raw_item.elements['pubDate']
      item[:publication_date] = raw_item.elements['pubDate'].text
    end
    raw_item.each_recursive do |childElement|
      item[:keywords] << childElement.text if childElement.name == "category"
      if childElement.name == "content" && childElement.attributes["medium"].present?
        item[:media_contents] << {:url => childElement.attributes["url"], :medium => childElement.attributes["medium"]}
      elsif childElement.name == "enclosure"
        item[:media_contents] << {:url => childElement.attributes["url"], :medium => childElement.attributes["type"]}
      end
    end
    return item
  end

end

end