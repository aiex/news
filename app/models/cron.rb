class Cron < ActiveRecord::Base
  attr_accessible :status, :finished_at
end
