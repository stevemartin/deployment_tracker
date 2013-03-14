require 'resque'
require './git_clone'

loop do
	sleep(10)
	klass, args = Resque.reserve(:git_clone)
        klass.perform(*args) if klass.respond_to? :perform
end
