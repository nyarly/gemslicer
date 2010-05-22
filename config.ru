$LOAD_PATH.unshift File.dirname(__FILE__) + "/app"
$LOAD_PATH.unshift File.dirname(__FILE__) + "/lib"

require "rubygems"
require "api"

run Gemslicer::Api
