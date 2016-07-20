require "open-uri"
require "nokogiri"
require "colorize"

require_relative "apod_cli/cli"
require_relative "apod_cli/printer"
require_relative "apod_cli/scraper"

class ApodCli
  def call
    CLI.new.call
  end
end