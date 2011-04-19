$LOAD_PATH.unshift(File::expand_path("../lib", __FILE__))
require 'rubygems'
require "gemslicer"
require 'rack/logger'
require 'rack/showexceptions'

Gemslicer::configure_server_root!(File::expand_path("../public", __FILE__))

use Rack::ShowExceptions
use Rack::Logger
use Gemslicer::Api
use Gemslicer::Proxy
run Gemslicer::Hostess
