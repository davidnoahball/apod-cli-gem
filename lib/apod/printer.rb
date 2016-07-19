require "colorize"

class Printer
  def print_link(link_hash)
    "The astronomy picture of the day on " + link_hash[:date].colorize(:green) + " was " + link_hash[:name].colorize(:green) + "."
  end
  def print_page

  end
end