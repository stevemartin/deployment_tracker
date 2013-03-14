$(function() {
    setInterval("getDataFromWS()", 8000) // 300,000 miliseconds is 5 minutes
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

$(document).ready(function(){
	$('a#updating_repo').hide()
	$('#updating_repo').on('click', function(e) {
	    $('a#updating_repo').hide();
	    $.get(this.href);
	    $('input#for_refresh').val('true');
            return false;
	});
});
