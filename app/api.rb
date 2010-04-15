require 'gemslicer'
require 'hostess'

module Gemslicer
  class Api < Sinatra::Base
    use Gemslicer::Hostess
    
    enable :logging
    
    post "/api/v1/gems" do
      slicer = Slicer.new(request.body, request.host_with_port)
      slicer.process      
      status(slicer.code)
      body(slicer.message)
    end
    
    error do
      env['sinatra.error'].name
    end
  end
end
