require "nokogiri"
require "open-uri"

class Scraper
  def self.get_page
    Nokogiri::HTML(open("http://apod.nasa.gov/apod/archivepix.html"))
  end

  def self.dates_hash
    array = []
    content = self.get_page.css("body b")
    date_titles = content.text.split("\n").reject!{|item| item == ""}
    date_titles.pop
    date_titles.each do |dt|
      hash = {}
      hash[:original] = dt
      hash[:date] = "#{dt.slice(0, 4)}-#{dt.match(/[0-9]{2}/, 5)}"
      hash[:title] = nil
      array << hash
    end
    array
  end
end

p Scraper.dates_hash