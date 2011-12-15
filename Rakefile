require 'rubygems'
require 'rake/gempackagetask'
require 'rspec/core/rake_task'
require File.join(File.dirname(__FILE__), "lib", "crossroads.rb")

spec = Gem::Specification.new do |s|
  s.name = "crossroads"
  s.version = Crossroads.version
  s.author = "R.I.Pienaar"
  s.email = "rip@devco.net"
  s.homepage = "https://github.com/ripienaar/crossroads/"
  s.summary = "Routing system for JSON messages on STOMP middleware"
  s.description = "A router that consumes STOMP middleware and routes data to other destinations based on simple rules expressed in Ruby"
  s.files = FileList["{bin,lib}/**/*"].to_a
  s.require_path = "lib"
  s.test_files = []
  s.has_rdoc = true
  s.executables = "crossroads"
  s.default_executable = "crossroads"

  s.add_dependency("stomp")
  s.add_dependency("jgrep", ">=1.3.1")
  s.add_dependency("json")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

task :default => :repackage
