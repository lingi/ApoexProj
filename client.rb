# A client for searching allabolag.se
# Before running a database (db_AllaBolag) in mysql has to be created by e.g.
# "create database db_AllaBolag;"
# Then to set up the database type "rake db:migrate RAILS_ENV=development"
# Run the project to start the server
# To search either run this file from the console by: "ruby client.rb companyname"
# or connect to "localhost:3000/companies" in browser

ENV['RAILS_ENV'] ||= 'development'
require File.expand_path(File.dirname(__FILE__) + "/config/environment")
require 'open-uri'
require 'nokogiri'

port = 3000 #Default
type = '/companies.json'

inputString = ARGV.join("+") #this allows for multiple search text e.g. "apoex ab"

url = "http://localhost:#{port}#{type}?query=#{inputString}"

content = open(url)#Returns answers in json format
companies = JSON.parse(content.string)#parse into object

if companies.any?
  puts "Resultat"
  companies.each do |c|
    puts "#{c.to_yaml.force_encoding('utf-8').encode}"
  end
else
  puts "Inga resultat"
end