require_relative "../apod/scraper.rb"
require_relative "../apod/printer.rb"

scrape = Scraper.new
print = Printer.new
puts print.print_link(scrape.data[0])