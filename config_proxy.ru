$LOAD_PATH.unshift File.dirname(__FILE__) + "/lib"
$LOAD_PATH.unshift File.dirname(__FILE__) + "/app"

require "rubygems"
require "proxy"

run Gemslicer::Proxy
