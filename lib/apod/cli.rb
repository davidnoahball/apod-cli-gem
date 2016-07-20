require_relative "../apod/scraper.rb"
require_relative "../apod/printer.rb"
require "colorize"

scrape = Scraper.new
print = Printer.new
#print.print_link(scrape.data[1000], "[1]".colorize(:red))
data = scrape.data
data.each_with_index do |hash, idx|
  puts [hash[:date], idx]
  #print.print_page(scrape.pic_data(hash[:link]))
end