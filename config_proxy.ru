$LOAD_PATH.unshift File.dirname(__FILE__) + "/lib"
$LOAD_PATH.unshift File.dirname(__FILE__) + "/app"

require "proxy"

run Gemslicer::Proxy