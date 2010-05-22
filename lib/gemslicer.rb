require 'fileutils'
require 'gemslicer/vault'
require 'gemslicer/slicer'

module Gemslicer
  def self.server_path(*more)
    Slicer.server_path(*more)
  end

  def self.indexer
    Slicer.indexer
  end
  
  def self.proxy_server_path(*more)
    server_path('proxy_tmp', *more)
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
                  
