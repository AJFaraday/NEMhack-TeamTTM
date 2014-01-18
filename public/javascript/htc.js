function refresh_messages() {
  jQuery.ajax({
    type: 'GET',
    cache: false,
    url: '/get_messages',
    success: function(response){
      $('.bus_content').html('');
      var data = JSON.parse(response);
      for (var key in data) {
        $('#'+key).html(data[key]);
      }
    }
  });
}


var $waiting = false
var $score_polling
function refresh_score() {
  jQuery.ajax({
    type: 'GET',
    cache: false,
    url: '/refresh_score',
    success: function(response){
      response = JSON.parse(response)
      if (response['new']){
        $('#fragment').attr('src',response['image_path']);        
        $('#no_score_message').hide();
        $('#refresh_message').show();
        // end polling if started
        if($waiting==true){
          window.clearInterval($score_polling);
          $waiting = false
        }
      } else {
        $('#no_score_message').show();
        $('#refresh_message').hide();
        //start polling
        if ($waiting==false) {
          $waiting = true
          $score_polling = setInterval(function(){refresh_score();}, 1000);
        } 
      }
    } 
  });
}

function start_polling(){
  setInterval(function() {
    refresh_messages();
  }, 1000)
}
