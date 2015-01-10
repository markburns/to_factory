require 'rubygems'
require 'rubygems/command.rb'
require 'rubygems/dependency_installer.rb' 
begin
  Gem::Command.build_args = ARGV
  rescue NoMethodError
end 
inst = Gem::DependencyInstaller.new


begin
  if RUBY_VERSION < "1.9.3"
    inst.install "activerecord", ">2.0", "< 4.0"
    inst.install 'i18n', "< 0.7"
  else
    inst.install "activerecord", "> 4.0"
  end
  rescue
    exit(1)
end 

f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w")   # create dummy rakefile to indicate success
f.write("task :default\n")
f.close