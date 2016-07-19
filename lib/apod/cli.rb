require_relative "../apod/scraper.rb"
require_relative "../apod/printer.rb"
require "colorize"

scrape = Scraper.new
print = Printer.new
print.print_link(scrape.data[1000], "[1]".colorize(:red))
print.print_link(scrape.data[508], "[2]".colorize(:red))
print.print_page({expl: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum volutpat lorem metus, vel ornare libero suscipit vel. Fusce facilisis mattis sem, a mattis sem aliquam vitae. Donec pellentesque mattis pellentesque. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Fusce posuere mauris sit amet augue consectetur, id malesuada quam consequat. Aliquam id risus et lacus rutrum sagittis et vitae mi. Nulla eget enim massa. In malesuada iaculis purus nec aliquet. Vestibulum maximus est in dictum vulputate. Sed feugiat ipsum ac lorem facilisis, at efficitur eros imperdiet. Aenean justo ante, eleifend sit amet iaculis ut, luctus eu magna. Suspendisse ut diam vel tortor hendrerit consequat. Donec magna neque, sodales vitae diam at, pulvinar auctor odio. Sed eget ipsum aliquet nulla placerat volutpat. In efficitur metus vitae eros luctus congue.", name:"Star Streams and the Whale Galaxy", link:"http://apod.nasa.gov/apod/image/1512/gabanyNGC4631withSatStream.jpg"})