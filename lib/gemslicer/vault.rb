module Gemslicer
  module Vault
    module FS
      def write_gem
        cache_path = Gemslicer.server_path('gems', "#{spec.original_name}.gem")
        File.open(cache_path, "wb") do |f|
          f.write body.string
        end
        File.chmod 0644, cache_path

        quick_path = Gemslicer.server_path("quick", "Marshal.4.8", "#{spec.original_name}.gemspec.rz")
        FileUtils.mkdir_p(File.dirname(quick_path))

        Gemslicer.indexer.abbreviate spec
        Gemslicer.indexer.sanitize spec
        File.open(quick_path, "wb") do |f|
          f.write Gem.deflate(Marshal.dump(spec))
        end
        File.chmod 0644, quick_path
      end
    end
  end
end
