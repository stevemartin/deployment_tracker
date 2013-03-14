$(function() {
    setInterval("getDataFromWS()", 10000) // 300,000 miliseconds is 5 minutes
});

function getDataFromWS() {
    $.ajax({
        type:'Get',
        url:'/status'}).done(function(message) { 
	    alert(message);
            $('p#current_status').text(message);
        }
    })
}

$(document).ready(function(){
	$('#updating_repo').live('click', function(e) {
	alert("updating!");
	});
});
