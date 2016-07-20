require "open-uri"
require "nokogiri"
require "colorize"

require_relative "printer"
require_relative "scraper"

class CLI
  def call #All CLI logic should come from this command
    @scraper = Scraper.new
    @printer = Printer.new
    @data = @scraper.data
    puts "\nHello.\n"
    start
  end

  def start
    puts "Which type of lookup would you like to perform?"
    puts ""
=begin
    @data.each_with_index do |hash, idx|
      @printer.print_link(@data[1000], "[#{idx + 1}] ")
      @printer.print_page(@scraper.pic_data(hash[:link]))
    end
=end

    puts "Would you like to perform another lookup?\n[y/n]"
    if valid_input(["y", "n"]) == "y"
      puts ""
      start
    else
      puts "Goodbye."
    end
  end

  def valid_input(wanted)
  input = gets.chomp.downcase
  if wanted.include?(input)
    return input
  else
    puts "That's not a valid input! Please try again."
    valid_input(wanted)
  end
end
end