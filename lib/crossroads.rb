module Crossroads
  VERSION = "0.0.1"

  ["jgrep", "logger", "yaml", "json", "stomp", "crossroads/route", "crossroads/router",
    "crossroads/log", "crossroads/runner", "crossroads/stomp"].each do |r|
    require r
   end

  def self.version
    VERSION
  end

  def self.runner(configfile)
    Runner.new(configfile)
  end

  def self.daemonize
    fork do
      Process.setsid
      exit if fork
      Dir.chdir('/tmp')
      STDIN.reopen('/dev/null')
      STDOUT.reopen('/dev/null', 'a')
      STDERR.reopen('/dev/null', 'a')

      yield
    end
  end
end
