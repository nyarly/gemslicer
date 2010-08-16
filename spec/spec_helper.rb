require 'rubygems'
require 'spec'

ENV["RACK_ENV"] ||= 'test'

require 'gemslicer'

module SpecHelper
  TEST_SERVER_ROOT = File.join(File.dirname(__FILE__), 'tmp')
  
  def test_server_root
    TEST_SERVER_ROOT
  end
end

Spec::Runner.configure do |config|
  config.include(SpecHelper)
end
