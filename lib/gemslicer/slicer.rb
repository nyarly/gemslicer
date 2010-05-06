require 'rubygems/format'
require 'rubygems/indexer'

module Gemslicer
  class Slicer
    include Vault::FS
    
    attr_reader :spec, :message, :code, :body
    
    def self.server_path(*more)
      File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'server', *more))
    end
    
    def self.indexer
      @indexer ||= 
        begin
          indexer = Gem::Indexer.new(Gemslicer.server_path, :build_legacy => false)
          def indexer.say(message) end
          indexer
        end
    end
    
    def initialize(body)
      @body = StringIO.new(body.read)
    end
    
    def process
      pull_spec && save
    end
    
    def save        
      write_gem
      update_index
      notify("Successfully registered gem: #{@spec.full_name}", 200)
    end
    
    def notify(message, code)
      @message = message
      @code    = code
      false
    end
    
    def pull_spec
      begin
        format = Gem::Format.from_io(body)
        @spec = format.spec
      rescue Exception => e
        notify("RubyGems cannot process this gem.\n" +
               "Please try rebuilding it and installing it locally to make sure it's valid.\n" +
               "Error:\n#{e.message}\n#{e.backtrace.join("\n")}", 422)
      end
    end
    
    # Overridden so we don't get megabytes of the raw data printing out
    def inspect
      attrs = [:@message, :@code].map { |attr| "#{attr}=#{instance_variable_get(attr) || 'nil'}" }
      "<Gemslicer #{attrs.join(' ')}>"
    end
    
    def update_index
      log "Updating the index"
      self.class.indexer.generate_index
      log "Finished updating the index"   
    rescue => e
      log "Error updating the index: #{e.message}"
    end
          
    def log(message)
      # TODO: get a real logger
      $stdout.puts "[GEMSLICER:#{Time.now}] #{message}"
    end
  end 
 end
