require "colorize"

class Printer
  def print_link(link_hash, start="")
    puts start + "The astronomy picture of the day on " + link_hash[:date].colorize(:green) + " was " + link_hash[:name].colorize(:green) + "."
  end
  def print_page(page_hash)
    words_arr = page_hash[:expl].split(" ")
    line = ""
    lines_arr = []
    max_line_length = 0
    words_arr.each_with_index do |word, idx|
      line += word + " "
      if line.length >= 45 || idx == words_arr.length - 1
        lines_arr << line.strip
        if line.strip.length > max_line_length then max_line_length = line.strip.length end
        line = ""
      end
    end
    lines_arr.each do |line|
      puts pad(max_line_length, line)
    end
  end
  def pad(max, str)
    pad = ""
    padding_amount = ((max - str.length) / 2).ceil
    padding_amount.times do |n|
      pad += " "
    end
    centered = "#{pad}#{str}#{pad}"
  end
end