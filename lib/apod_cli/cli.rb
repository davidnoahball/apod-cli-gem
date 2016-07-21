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
    puts "[3]".colorize(:red) + " Search by date and name"
    puts "[4]".colorize(:red) + " Sample data"
    search_type = valid_input(["1", "2", "3", "4"]).to_i
    case search_type
    when 1
      date_search
    when 2
      name_search
    when 3
      date_search(true)
    when 4
      sample
    end
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
    puts "\nPlease enter the number (" + "[1]".colorize(:red) + " - " + "[#{@data.length}]".colorize(:red) + ") of links you would\nlike to sample. Or, type " + "'all'".colorize(:red) + " for information on all results."
    wanted = [(1..@data.length).to_a.map{|e| e.to_s}, "all"].flatten
    num = valid_input(wanted)
    sample = @data.sample(num.to_i)
    print_links(sample)
    more_info(sample)
  end

  def date_search(multisearch=false)
    results = []
    puts "\nWhich type of date search would you like to perform?"
    puts "[1]".colorize(:red) + " exact date"
    puts "[2]".colorize(:red) + " date in each year"
    puts "[3]".colorize(:red) + " date range"
    date_search_type = valid_input(["1", "2", "3"]).to_i
    case date_search_type
    when 1
      puts "\nPlease enter a date in the format yyyy-mm-dd. The oldest is 1995-06-16."
      input = gets.chomp.strip
      @data.each do |hash|
        if hash[:date] == input
          results << hash
          break
        end
      end
      if results == []
        puts "Date not found!"
        return
      end
      puts ""
      print_links(results)
      print_pages(results)
      return
    when 2
      puts "\nPlease enter a day of the year in the format mm-dd."
      input = gets.chomp.strip
      @data.each do |hash|
        if hash[:date].slice(5..-1) == input
          results << hash
        end
      end
      if results == []
        puts "Day not found! Did you use the correct format?"
        return
      end
    when 3

    end
    if multisearch then results = name_search(results) end
    print_links(results)
    more_info(results)
  end

  def name_search(searchspace=@data)
    puts "\nPlease enter one or multiple " + "search terms".colorize(:red) + ", with each query comma\nseparated. Ex: 'lunar eclipse, blood moon'"
    puts ""
    searchterms = gets.chomp.strip.downcase.split(",")
    results = []
    searchterms.each do |searchterm|
      searchterm.strip!
      results << searchspace.select{|hash| hash[:name].downcase.include?(searchterm)}
    end
    unique = results.flatten.uniq.sort{|h1, h2| h1[:date] > h2[:date] ? 1 : -1}
    if searchspace != @data then return unique end
    if unique == []
      puts "\nNo results found!"
      return
    end
    print_links(unique)
    puts ""
    more_info(unique)
  end

  def more_info(arr)
    puts "Would you like more information on one or more of these matches?"
    puts "[y/n]".colorize(:red)
    if valid_input(["y", "n"]) == "y"
      puts "Please enter the " + "results number".colorize(:red) + " of any link(s) you would like more\ninformation on, comma separated. Or, type " + "'all'".colorize(:red) + " for more information on all results."
      wanted = [(1..arr.length).to_a.map{|e| e.to_s}, "all"].flatten
      validated = false #Should maybe turn this into a valid_split method or something, but it's not necessary right now.
      while !validated
        searchterms = gets.chomp.strip.downcase.split(",")
        failed = false
        searchterms.each do |searchterm|
          searchterm.strip!
          if !wanted.include?(searchterm)
            puts "That's not a valid input! Please try again."
            failed = true
            break
          end
        end
        if !failed then validated = true end
      end
      if searchterms.include?("all")
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
      starter = "[#{idx + 1}]"
      ((arr.length.to_s.length + 3) - starter.length).times do |n|
        starter += " "
      end
      @printer.print_link(hash, starter)
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