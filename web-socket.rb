require 'em-websocket'
t0 = Thread.start do
  EventMachine.run {
    @channel = EM::Channel.new

    EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 4568, :debug => true) do |ws|

      ws.onopen {
        sid = @channel.subscribe { |msg| ws.send msg }
        @channel.push "#{sid} connected!"

        ws.onmessage { |msg|
	  if msg == "get_status"
            @channel.push `cat .updating_repo`
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
end

t1 = Thread.start do
  server = TCPServer.new 4569
  client = server.accept
  loop do
    data = client.readline
    @channel.push data
  end
end
