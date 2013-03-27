$:.unshift File.dirname(__FILE__)
require 'daemons'

Daemons.run('lib/web-socket.rb')
