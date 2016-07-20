require "open-uri"
require "nokogiri"
require "colorize"

require_relative "cli"
require_relative "scraper"

class Printer
  def print_link(link_hash, start="")
    lines = start.colorize(:red) + "The astronomy picture of the day on " + link_hash[:date].colorize(:green) + " was " + link_hash[:name].colorize(:green) + ".\n"
    start.length.times do |n|
      lines += " "
    end
    lines += "The link is " + link_hash[:link].colorize(:green) + "."
    puts lines
  end
  def print_page(page_hash)
    words_arr = page_hash[:expl].split(" ")
    line = ""
    lines_arr = []
    max_line_length = 0
    words_arr.each_with_index do |word, idx|
      line += word + " "
      if line.length >= 100 || idx == words_arr.length - 1
        lines_arr << line.strip
        if line.strip.length > max_line_length then max_line_length = line.strip.length end
        line = ""
      end
    end
    puts ""
    puts pad(max_line_length, page_hash[:name], "-").colorize(:red)
    puts pad(max_line_length, page_hash[:link], "-").colorize(:red)
    lines_arr.each do |line|
      puts pad(max_line_length, line)
    end
    puts ""
  end
  def pad(max, str, char=" ")
    pad = char
    padding_amount = ((max - str.length) / 2).ceil
    padding_amount.times do |n|
      pad += char
    end
    centered = "#{pad}#{str}#{pad}"
  end
end