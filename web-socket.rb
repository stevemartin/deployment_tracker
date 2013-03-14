require 'em-websocket'
t0 = Thread.start do
  EventMachine.run {
    @channel = EM::Channel.new

    EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 90210, :debug => true) do |ws|

      ws.onopen {
        sid = @channel.subscribe { |msg| ws.send msg }
        @channel.push "#{sid} connected!"

        ws.onmessage { |msg|
          @channel.push "<#{sid}>: #{msg}"
        }

        ws.onclose {
          @channel.unsubscribe(sid)
        }
      }

    end

  }
end
