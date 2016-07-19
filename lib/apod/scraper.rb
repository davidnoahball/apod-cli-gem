require "nokogiri"
require "open-uri"

class Scraper
  def self.get_page
    Nokogiri::HTML(open("http://apod.nasa.gov/apod/archivepix.html"))
  end

  def self.dates_hash
    array = []
    months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    content = self.get_page.css("body b")
    date_titles = content.text.split("\n").reject!{|item| item == "" || item == ""}
    date_titles.pop

    date_titles.each_with_index do |dt, idx|
      hash = {}
      if idx == date_titles.length - 1 || months.index(date_titles[idx + 1].match(/[a-zA-Z]{1,}/).to_s).nil?
        date_titles[idx] = "#{date_titles[idx]} #{date_titles[idx + 1]}"
        date_titles.delete_at(idx + 1)
      end
      hash[:date] = "#{dt.match(/[0-9]{4}/)}-#{months.index(dt.match(/[a-zA-Z]{1,}/).to_s) + 1}-#{dt.match(/[0-9]{2}/)}"
      array << hash
    end

    array
  end
end

p Scraper.dates_hash