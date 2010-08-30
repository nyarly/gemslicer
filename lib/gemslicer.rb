require 'fileutils'
require 'gemslicer/vault'
require 'gemslicer/slicer'

module Gemslicer
  
  autoload :Options, "gemslicer/options"
  autoload :Api, "gemslicer/api"
  autoload :Proxy, "gemslicer/proxy"

  extend self

  attr_reader :server_root
  
  def configure_server_root!(root)
    @server_root = File.expand_path(root)
    ensure_server_paths_exist
    ensure_proxy_server_paths_exist
  end

  def reset_server_root
    @server_root = nil
  end

  def server_path(*more)
    File.join(self.server_root, *more)
  end
    
  def proxy_server_path(*more)
    server_path('proxy_tmp', *more)
  end

  def indexer
    Slicer.indexer
  end
    
  # Generating the index is an easy way to make sure required
  # directories exists  
  def ensure_server_paths_exist
    return if File.exist? File.join(server_path, "gems")
    Gemslicer::Slicer.new_indexer(server_path).generate_index 
    FileUtils.mkdir_p File.join(server_path, 'gems')
  end

  def ensure_proxy_server_paths_exist
    return if File.exist?(proxy_server_path)
    Gemslicer::Slicer.new_indexer(proxy_server_path).generate_index 
  end
end
