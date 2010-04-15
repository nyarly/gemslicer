$LOAD_PATH.unshift File.dirname(__FILE__) + "/app"
$LOAD_PATH.unshift File.dirname(__FILE__) + "/lib"

require "api"

run Gemslicer::Api
