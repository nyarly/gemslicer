require 'gemslicer/vault'
require 'gemslicer/slicer'

module Gemslicer
  def self.server_path(*more)
    Slicer.server_path(*more)
  end

  def self.indexer
    Slicer.indexer
  end  
end
                  
