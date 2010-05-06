require 'net/http'
require 'gemslicer'
require 'hostess'

class Gemslicer::Proxy < Sinatra::Base
  class Middleware < Sinatra::Base
    
    set :upstream, "http://rubygems.org"
    set :upstream_redirects_max, 3
    
    before do
      env['gemslicer.server_root'] = Gemslicer::ProxyServerRoot
    end
    
    get "/gems/*.gem" do      
      slicer = Gemslicer::Slicer.new(Gemslicer::ServerRoot, download_upstream)
      slicer.process
      if slicer.code == 200
        forward
      else
        content_type(:text)
        status(slicer.code)
        body(slicer.message)
      end
    end

    get "/*" do
      File.open(server_path, 'w') {|f| f.write(download_upstream) }
      forward
    end
    
    def server_path
      Gemslicer.server_path(Gemslicer::ProxyServerRoot, request.path_info)
    end
    
    def upstream_url
      settings.upstream + request.path_info
    end
    
    def download_upstream(url = upstream_url, redirect_count = 0)
      uri = URI.parse(url)
      Net::HTTP.get_response(uri) do |res| 
        case res
        when Net::HTTPSuccess
          return res.read
        when Net::HTTPRedirection
          if redirect_count < settings.upstream_redirects_max
            return download_upstream(res['location'], redirect_count + 1)
          end
        end
        raise Sinatra::NotFound, url        
      end      
    end
    
  end
  
  use Gemslicer::Proxy::Middleware
  use Gemslicer::Hostess
  
  enable :logging
end
