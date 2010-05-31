require "net/http"
require "gemslicer/hostess"

module Gemslicer
  
  class Proxy < Sinatra::Base
    class Middleware < Sinatra::Base
    
      set :upstream, "http://rubygems.org"
      set :upstream_redirects_max, 3
        
      %w[/specs.4.8.gz
         /latest_specs.4.8.gz
         /prerelease_specs.4.8.gz
         /quick/Marshal.4.8/*.gemspec.rz
         /quick/rubygems-update-1.3.6.gemspec.rz
         /yaml.Z
         /yaml.z
         /Marshal.4.8.Z
         /quick/index.rz
         /quick/latest_index.rz
         /yaml
         /Marshal.4.8
         /specs.4.8
         /latest_specs.4.8
         /prerelease_specs.4.8
         /quick/index
         /quick/latest_index].each do |path|
        get path do               
          proxy_path = Gemslicer.proxy_server_path(request.path_info)
          File.open(proxy_path, 'w') {|f| f.write download(upstream_url) }
          env['gemslicer.server_path'] = proxy_path        
          forward
        end
      end
      
      get "/gems/*.gem" do
        return forward if File.exist? Gemslicer.server_path(request.path_info)

        slicer = Gemslicer::Slicer.new download(upstream_url)
        slicer.process

        return forward if slicer.code == 200

        content_type(:text)
        status(slicer.code)
        body(slicer.message)
      end
    
      not_found do
        content_type(:text)
        ""
      end
      
      private
      
      def upstream_url
        settings.upstream + request.path_info
      end
    
      def download(url, redirect_count = 0)
        Net::HTTP.get_response URI.parse(url) do |res| 
          case res
          when Net::HTTPSuccess
            return res.read_body
          when Net::HTTPRedirection
            if redirect_count < settings.upstream_redirects_max
              return download(res['location'], redirect_count + 1)
            end
          end
          raise Sinatra::NotFound, url        
        end      
      end    
    end
  
    use Proxy::Middleware
    use Hostess
  
    enable :logging
  end
end
