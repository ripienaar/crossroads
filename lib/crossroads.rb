module Crossroads
  VERSION = "0.0.1"

  require 'jgrep'
  require 'logger'
  require 'yaml'
  require 'json'
  require 'stomp'
  require 'crossroads/route'
  require 'crossroads/router'
  require 'crossroads/log'
  require 'crossroads/runner'
  require 'crossroads/stomp'

  def self.version
    VERSION
  end
end
