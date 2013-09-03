class DbLogger
  def self.log(message=nil)
    @@mail_log ||= Logger.new("#{Rails.root}/log/db.log")
    @@mail_log.debug(message) unless message.nil?
  end
end