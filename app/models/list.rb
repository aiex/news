class List < ActiveRecord::Base
  attr_accessible :name, :rss_link_ids, :user_id
  serialize :rss_link_ids, Array
  validates :name, presence: true

  after_destroy :remove_references

  class << self

    def manage_list_rss_association(list_id, rss_id, action)
      rss, list = RssLink.select("id, list_ids").find_by_id(rss_id), List.select("id, rss_link_ids").find_by_id(list_id)
      return false if rss.nil? || list.nil?
      action == "remove" ? disconnect_list_with_rss(list, rss) : connect_list_with_rss(list, rss)
      return true
    end

    # Add rss_id to rss_link_ids of List & list_id to list_ids of RssLink
    def connect_list_with_rss(list, rss)
      list.rss_link_ids << rss.id
      rss.list_ids << list.id
      transaction do
        list.update_attribute(:rss_link_ids, list.rss_link_ids.uniq)
        rss.update_attribute(:list_ids, rss.list_ids.uniq)
      end
    end

    # Delete rss_id from rss_link_ids of List & list_id from list_ids of RssLink
    def disconnect_list_with_rss(list, rss)
      return false if rss.list_ids.empty? || list.rss_link_ids.empty?
      list.rss_link_ids.delete(rss.id)
      rss.list_ids.delete(list.id)
      transaction do
        list.update_attribute(:rss_link_ids, list.rss_link_ids.uniq)
        rss.update_attribute(:list_ids, rss.list_ids.uniq)
      end
    end

  end

  private
  def remove_references
    rss_links = RssLink.select("id, list_ids").where("id IN (?)", self.rss_link_ids)
    rss_links.each do |rss_link|
      next rss_link.list_ids.empty?
      # list_ids = rss_link.list_ids.clone.uniq
      # list_ids.delete(self.id)
      # rss_link.update_attribute(:list_ids, list_ids)
      rss_link.list_ids.delete(self.id)
      rss_link.update_attribute(:list_ids, rss_link.list_ids.uniq)
    end
  end
end
