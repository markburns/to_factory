require 'rubygems'
require 'rubygems/command.rb'
require 'rubygems/dependency_installer.rb' 
begin
  Gem::Command.build_args = ARGV
  rescue NoMethodError
end 
inst = Gem::DependencyInstaller.new
puts 'tests'
begin
  if RUBY_VERSION < "2.1.0"
    inst.install "to_factory", ">= 0.2.0", "< 1.0.0"
  else
    inst.install "to_factory", ">= 1.0.0"
  end
  rescue
    exit(1)
end 

f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w")   # create dummy rakefile to indicate success
f.write("task :default\n")
f.close