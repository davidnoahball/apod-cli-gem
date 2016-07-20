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
      date_search
    when 2
      name_search
    when 3
      sample
    end
=begin
    @data.each_with_index do |hash, idx|
      @printer.print_link(@data[1000], "[#{idx + 1}] ")
      @printer.print_page(@scraper.pic_data(hash[:link]))
    end
=end
    puts "Would you like to perform another lookup?"
    puts "[y/n]".colorize(:red)
    if valid_input(["y", "n"]) == "y"
      puts ""
      start
    else
      puts "Goodbye."
    end
  end

  def sample

  end

  def name_search
    puts "Please enter one or multiple " + "search terms".colorize(:red) + ", with each query comma separated."
    searchterms = gets.chomp.strip.downcase.split(",")
    results = []
    searchterms.each do |searchterm|
      searchterm.strip!
      results << @data.select{|hash| hash[:name].downcase.include?(searchterm)}
    end
    unique = results.flatten.uniq.sort{|h1, h2| h1[:date] > h2[:date] ? 1 : -1}
    print_links(unique)
    more_info(unique)
  end

  def more_info(arr)
    puts "Would you like more information on one or more of these matches?"
    puts "[y/n]".colorize(:red)
    if valid_input(["y", "n"]) == "y"
      puts "Please enter the " + "results number".colorize(:red) + " of any link(s) you would like more\ninformation on, comma separated. Or, type " + "'all'".colorize(:red) + " for more information on all results."
      wanted = [(1..arr.length).to_a.map{|e| e.to_s}, "all"].flatten
      searchterms = valid_input(wanted).split(",")
      if searchterms == ["all"]
        print_pages(arr)
      else
        selected = []
        searchterms.each do |searchterm|
          selected << arr[searchterm.to_i - 1]
        end
        print_pages(selected)
      end
    end
  end

  def print_links(arr)
    arr.each_with_index do |hash, idx|
      @printer.print_link(hash, "[#{idx + 1}] ")
    end
  end

  def print_pages(arr)
    arr.each do |hash|
      @printer.print_page(@scraper.pic_data(hash[:link]))
    end
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