require "open-uri"
require "nokogiri"
require "colorize"

require_relative "printer"
require_relative "scraper"

class CLI
  def call #All CLI logic should come from this command
    puts "\nHello.\n"
    @scraper = Scraper.new
    @printer = Printer.new
    @data = @scraper.data
    start
  end

  def start
    puts "Which type of APOD lookup would you like to perform?"
    puts "[1]".colorize(:red) + " Search by date"
    puts "[2]".colorize(:red) + " Search by name"
    puts "[3]".colorize(:red) + " Sample data"
    search_type = valid_input(["1", "2", "3"]).to_i
    case search_type
    when 1
      search(:date)
    when 2
      search(:name)
    when 3
      sample
    end
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

  def sample

  end

  def search(type)
    search_array = []
    results = @data.select{|hash| search_array.include?(hash[type])}
  end

  def print_links(arr)

  end

  def print_pages(arr)

  end

  def valid_input(wanted)
  input = gets.chomp.strip.downcase
  if wanted.include?(input)
    return input
  else
    puts "That's not a valid input! Please try again."
    valid_input(wanted)
  end
end
end