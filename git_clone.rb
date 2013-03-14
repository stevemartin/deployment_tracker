require 'resque'
class GitClone
  @queue = :git_clone
  def self.perform channel
    #`git clone git@github.com:FundingCircle/funding_circle_app.git`
    #`rm -rf funding_circle_app_ready`
    #`mv funding_circle_app funding_circle_app_ready`
    `echo 'synced' > .updating_repo`
    channel.push "synced"
  end
end

