      function init() {
        function debug(string) {
          var element = document.getElementById("debug");
          var p = document.createElement("p");
          p.appendChild(document.createTextNode(string));
          old = element.firstChild;
          element.replaceChild(p, old);
        }

        function updatePage(message) {
           if(message == "synced\n"){
	     $('a#updating_repo').show();
	     $('#current_status').text("Synced.");
             $('#time_running').html("")
           } else if(message == "synced_refresh\n"){
             location.reload();
           } else if(message == "updating\n"){
	     $('a#updating_repo').hide();
	     $('#current_status').text("Updating...");
           } else {
             $('#time_running').html(message)
           }
        }

        var Socket = "MozWebSocket" in window ? MozWebSocket : WebSocket;
        var ws = new Socket("ws://localhost:4568/");
        ws.onmessage = function(evt) { updatePage(evt.data); };
        ws.onclose = function() { debug("socket closed"); };
        ws.onopen = function() {
          ws.send("get_status");
        }
        $('#updating_repo').on('click', function(e) {
            $('a#updating_repo').hide();
            ws.send("update_repo");
            $('#current_status').text("Updating...");
            $('input#for_refresh').val('true');
                return false;
        });
      };

$(document).ready(function(){
	$('a#updating_repo').hide()
	init();
});
