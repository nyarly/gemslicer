$LOAD_PATH << File.join(File.dirname(__FILE__), "lib")

require "rubygems"
require "gemslicer"

run Gemslicer::Api
