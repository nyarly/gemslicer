require 'optparse'

module Gemslicer
  
  class Options
    def initialize(app)
      @app = app
    end
    
    def parse!(args)      
      options = {        
        :port => 3027,
        :environment => :production
      }      
      OptionParser.new do |op|
        op.banner = "Usage: #{@app} [server options] [gemslicer options]"               
        
        op.separator ""
        op.separator "Server options:"
        
        op.on("-s", "--server SERVER", "serve using SERVER (webrick/mongrel)") do |server|
          options[:server] = server
        end

        op.on("-o", "--host HOST", "listen on HOST (default: 0.0.0.0)") do |host|
          options[:host] = host
        end

        op.on("-p", "--port PORT", "use PORT (default: 3027)") do |port|
          options[:port] = port
        end

        op.on("-E", "--env ENVIRONMENT", "use ENVIRONMENT for defaults (default: production)") do |e|
          options[:environment] = e
        end
        
        op.on("-x", "--lock") do
          options[:lock] = true
        end
                
        op.separator ""
        op.separator "Gemslicer options:"

        op.on("-d",
              "--directory DIRNAME",
              "repository base dir containing gems subdir (default: '.')") do |dirname|
          Gemslicer.configure_server_root!(dirname)
        end
        
        op.separator ""
        op.separator "Common options:"

        op.on_tail("-h", "--help", "Show this message") do
          puts op
          exit
        end
        
        op.on_tail("--version", "Show version") do
          version = File.read(File.dirname(__FILE__) + "/../VERSION") 
          puts "Gemslicer #{version}"
          exit
        end        
      end.parse!(args)

      if Gemslicer.server_root.nil?
        Gemslicer.configure_server_root! File.expand_path(".")
      end
            
      options
    end
  end
  
end
