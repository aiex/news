# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
if Category.all.blank?
  Category.create(name: "Entertainment")
  Category.create(name: "Top News")
  Category.create(name: "Latest News")
  Category.create(name: "Sports")
  Category.create(name: "Cricket")
  Category.create(name: "Technology")
end
