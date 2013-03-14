require 'resque'
require 'socket'
class GitClone
  @queue = :git_clone
  def self.perform 
    `git clone git@github.com:FundingCircle/funding_circle_app.git`
    `rm -rf funding_circle_app_ready`
    `mv funding_circle_app funding_circle_app_ready`
    `echo 'synced' > .updating_repo` 
    sock = TCPSocket.open('localhost', 4569)
    sock.puts "synced_refresh\n"
  end
end

