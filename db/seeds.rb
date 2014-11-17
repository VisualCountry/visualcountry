# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ActiveRecord::Base.transaction do
  Interest.create(interest:'DIY')
  Interest.create(interest:'Fashion')
  Interest.create(interest:'Art/Design')
  Interest.create(interest:'Animals')
  Interest.create(interest:'Comedy')
  Interest.create(interest:'Gaming')
  Interest.create(interest:'Sports')
  Interest.create(interest:'Music')
  Interest.create(interest:'Lifestyle')
  Interest.create(interest:'Travel')
  Interest.create(interest:'Celebrity')
  Interest.create(interest:'Photography')
  Interest.create(interest:'Technology')
  Interest.create(interest:'Food')
  Interest.create(interest:'Curation')  
end