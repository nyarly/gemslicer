require 'fileutils'
require 'gemslicer/vault'
require 'gemslicer/slicer'

module Gemslicer
  def self.server_root=(root)
    @server_root = File.expand_path(root)      
  end
  
  def self.server_root
    @server_root ||= File.expand_path File.join(File.dirname(__FILE__), '..', 'server')
  end

  def self.reset_server_root
    @server_root = nil
  end

  def self.server_path(*more)
    File.join(self.server_root, *more)
  end
    
  def self.proxy_server_path(*more)
    server_path('proxy_tmp', *more)
  end

  def self.indexer
    Slicer.indexer
  end
    
  # Generating the index is an easy way to make sure required
  # directories exists  
  def self.ensure_server_paths_exist
    Gemslicer::Slicer.new_indexer(server_path).generate_index    
    FileUtils.mkdir_p File.join(server_path, 'gems')
  end

  def self.ensure_proxy_server_paths_exist   
    Gemslicer::Slicer.new_indexer(proxy_server_path).generate_index
  end
  
end
