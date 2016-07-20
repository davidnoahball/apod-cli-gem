require "nokogiri"
require "open-uri"

class Scraper
  def initialize
    @@data = self.class.index_data
  end

  def data
    @@data
  end

  def self.get_page
    Nokogiri::HTML(open("http://apod.nasa.gov/apod/archivepix.html"))
  end

  def pic_data(url)
    content = Nokogiri::HTML(open(url)).css("body").text.match(/Explanation:[\s\S]+?(\n(\s*)){3}/).to_s.gsub(/\n/, " ").gsub(/\s{2,}/, " ").strip
  end

  def self.index_data
    array = []
    months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    content = self.get_page.css("body b")
    links = content.css("a")
    date_titles = content.text.split("\n").reject!{|item| item == ""}
    date_titles.pop

    links_hash = {}
    links.each do |link|
      links_hash[link.text.strip] = link.attribute("href").value
    end

    toggle_2007 = false
    date_titles.each_with_index do |dt, idx|
      hash = {}
      #There's one bloody link with a \n typo in its name that requires me to write this code.
      if idx == date_titles.length - 1 || months.index(date_titles[idx + 1].match(/[a-zA-Z]{1,}/).to_s).nil?
        if idx != date_titles.length - 1
          toggle_2007 = true
          next
        end
      end
      if toggle_2007
        toggle_2007 = false
        next
      end

      month_str = ""
      month_num = months.index(dt.match(/[a-zA-Z]{1,}/).to_s) + 1
      if month_num.to_s.length == 1
        month_str = "0#{month_num}"
      else
        month_str = month_num.to_s
      end

      name_i = dt.match(/:.+/).to_s
      name_i[0] = " "

      hash[:date] = "#{dt.match(/[0-9]{4}/)}-#{month_str}-#{dt.match(/[^0-9][0-9]{2}[^0-9]/).to_s.gsub(/[: ]/, "")}"
      hash[:name] = name_i.strip
      hash[:link] = "http://apod.nasa.gov/apod/" + links_hash[hash[:name]]
      array << hash
    end

    array << {date: "2007-07-16", name: "The Lagoon Nebula in Gas, Dust, and Stars", link: "ap070716.html"} #This is the dumb typo'd link that I decided to hardcode.
    array
  end
end