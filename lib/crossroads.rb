module Crossroads
  VERSION = "0.0.1"

  require 'jgrep'
  require 'logger'
  require 'crossroads/route'
  require 'crossroads/router'
  require 'crossroads/log'

  def self.version
    VERSION
  end
end
