# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ActiveRecord::Base.transaction do
  Interest.create(name:'DIY')
  Interest.create(name:'Fashion')
  Interest.create(name:'Art/Design')
  Interest.create(name:'Animals')
  Interest.create(name:'Comedy')
  Interest.create(name:'Gaming')
  Interest.create(name:'Sports')
  Interest.create(name:'Music')
  Interest.create(name:'Lifestyle')
  Interest.create(name:'Travel')
  Interest.create(name:'Celebrity')
  Interest.create(name:'Photography')
  Interest.create(name:'Technology')
  Interest.create(name:'Food')
  Interest.create(name:'Curation')
end