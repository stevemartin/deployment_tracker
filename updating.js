$(function() {
    //setInterval("getDataFromWS()", 8000) // 300,000 miliseconds is 5 minutes
});

function getDataFromWS() {
    $.ajax({
        type:'Get',
        url:'/status'}).done(function(message) { 
	 if(message == 'synced\n') {
	    $('a#updating_repo').show()
	    if($('input#for_refresh').val() == "true"){
               location.reload()
	      }
         } else {
	    $('a#updating_repo').hide()
         }
	 $('p#current_status').text(message);
    })
}

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
           } else if(message == "synced_refresh\n"){
             location.reload();
           } else if(message == "updating\n"){
	     $('a#updating_repo').hide();
           }
        }

        var Socket = "MozWebSocket" in window ? MozWebSocket : WebSocket;
        var ws = new Socket("ws://intra.int.fundingcircle.com:4568/");
        //var ws = new Socket("ws://192.168.2.5:4568");
        ws.onmessage = function(evt) { updatePage(evt.data); };
        ws.onclose = function() { debug("socket closed"); };
        ws.onopen = function() {
          //debug("connected...");
          ws.send("get_status");
        };
      };

$(document).ready(function(){
	$('a#updating_repo').hide()
	$('#updating_repo').on('click', function(e) {
	    $('a#updating_repo').hide();
	    $.get(this.href);
	    $('input#for_refresh').val('true');
            return false;
	});
	init();
});
