# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create email: "benjamin.cousaert@12urenloop.be", password: "password"
Partner.create email: "benjamin.cousaert@12urenloop.be", name: "benji"
Partner.create email: "benjamin.cousaert@13urenloop.be", name: "don"
Partner.create email: "benjamin.cousaert@14urenloop.be", name: "elo"
