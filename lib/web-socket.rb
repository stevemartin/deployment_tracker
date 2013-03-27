require 'em-websocket'
#t0 = Thread.start do

  EventMachine.run {
    @channel = EM::Channel.new

    git_clone = Proc.new do
      `git clone git@github.com:FundingCircle/funding_circle_app.git #{File.join(File.dirname(__FILE__),'funding_circle_app')}`
      `rm -rf #{File.join(File.dirname(__FILE__),'funding_circle_app_ready')}`
      `mv #{File.join(File.dirname(__FILE__),'funding_circle_app')} #{File.join(File.dirname(__FILE__),'funding_circle_app_ready')}`
      `echo 'synced' > #{File.join(File.dirname(__FILE__),'.updating_repo')}`
    end

    gc_callback = Proc.new do
      @channel.push "synced_refresh\n"
    end

    EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 4568, :debug => true) do |ws|

      ws.onopen {
        sid = @channel.subscribe { |msg| ws.send msg }
        @channel.push "#{sid} connected!"

        ws.onmessage { |msg|
	      if msg == "get_status"
            @channel.push `cat #{File.join(File.dirname(__FILE__),'.updating_repo')}`
          elsif msg == "update_repo"
            `echo 'updating' > #{File.join(File.dirname(__FILE__),'.updating_repo')}`
            @channel.push "updating\n"
            EM.defer(git_clone, gc_callback)
          else
            @channel.push "#{msg}"
          end
        }

        ws.onclose {
          @channel.unsubscribe(sid)
        }
      }

    end

  }

