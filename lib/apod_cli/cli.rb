require "open-uri"
require "nokogiri"
require "colorize"

require_relative "printer"
require_relative "scraper"

class CLI
  def call
    start
  end
  def start
    scrape = Scraper.new
    print = Printer.new
    data = scrape.data
    data.each_with_index do |hash, idx|
      print.print_link(scrape.data[1000], "[1]".colorize(:red))
      print.print_page(scrape.pic_data(hash[:link]))
    end
  end
end