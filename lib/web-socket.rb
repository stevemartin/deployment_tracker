require 'yaml'
require 'em-websocket'

@config = YAML.load_file(File.join(File.dirname(__FILE__), '../config.yml'))
#t0 = Thread.start do

  EventMachine.run {
    @channel = EM::Channel.new

    git_clone = Proc.new do
      `git clone git@github.com:#{@config["github_user"]}/#{@config["repo"]}.git #{File.join(File.dirname(__FILE__),@config["repo"])}`
      `rm -rf #{File.join(File.dirname(__FILE__),"#{@config["repo"]}_ready")}`
      `mv #{File.join(File.dirname(__FILE__), @config["repo"])} #{File.join(File.dirname(__FILE__),"#{@config["repo"]}_ready")}`
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

