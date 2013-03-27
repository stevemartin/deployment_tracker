$:.unshift File.dirname(__FILE__)
require 'lib/track'

run Sinatra::Application
