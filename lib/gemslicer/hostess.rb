require 'sinatra/base'

module Gemslicer
  class Hostess < Sinatra::Base

    def serve
      send_file env['gemslicer.server_path'] ||
        Gemslicer.server_path(request.path_info)
    end

    get "/" do
      Gemslicer.server_root
    end       
    
    %w[/specs.4.8.gz
       /latest_specs.4.8.gz
       /prerelease_specs.4.8.gz
    ].each do |index|
      get index do
        content_type('application/x-gzip')
        serve
      end
    end

    %w[/quick/Marshal.4.8/*.gemspec.rz
       /quick/rubygems-update-1.3.6.gemspec.rz
       /yaml.Z
       /yaml.z
       /Marshal.4.8.Z
       /quick/index.rz
       /quick/latest_index.rz
    ].each do |deflated_index|
      get deflated_index do
        content_type('application/x-deflate')
        serve
      end
    end

    %w[/yaml
       /Marshal.4.8
       /specs.4.8
       /latest_specs.4.8
       /prerelease_specs.4.8
       /quick/index
       /quick/latest_index
    ].each do |old_index|
      get old_index do
        serve
      end
    end

    get "/gems/*.gem" do
      serve
    end
  end  
end
