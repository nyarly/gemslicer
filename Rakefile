require 'rubygems'
require 'spec/rake/spectask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'Gemslicer'
    gem.summary = 'Minimalist version of Gemcutter.'
    gem.description = "Minimalist version of Gemcutter. Supports 'gem push'."
    gem.has_rdoc = false
    gem.email = 'jeremy.burks@gmail.com'
    gem.homepage = "https://github.com/jrun/gemslicer"
    gem.authors = ["Jeremy Burks"]
    
    gem.files = %w(LICENSE README.rdoc Rakefile) + Dir.glob("{app,lib,spec,features}/**/*")
    
    gem.add_dependency 'sinatra', '>= 1.0'
    gem.add_development_dependency "rspec", ">= 1.3"   
    gem.add_development_dependency "cucumber", ">= 0.6"      

    desc "Install development dependencies."
    task :install_dependencies do
      gems = ::Gem::SourceIndex.from_installed_gems
      gem.dependencies.each do |dep|
        if gems.find_name(dep.name, dep.version_requirements).empty?
          puts "Installing dependency: #{dep}"
          system %Q|gem install #{dep.name} -v "#{dep.version_requirements}"  --development|
        end
      end
    end
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

desc "Run the examples"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = ["spec/**/*_spec.rb"]
  t.spec_opts = %w[--color --format specdoc --diff]  
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format pretty"
end

task :spec => :check_dependencies
task :default => [:spec, :features]
task :build => [:spec, :features]

