require "gemslicer/hostess"

module Gemslicer
  class Api < Sinatra::Base
    use Hostess

    enable :logging

    post "/api/v1/gems" do
      slicer = Slicer.new(request.body.read)
      slicer.process      
      status(slicer.code)
      body(slicer.message)
    end
    
    error do      
      env['sinatra.error'].name
    end

    not_found do
      content_type(:text)
      ""
    end
      
  end
end
