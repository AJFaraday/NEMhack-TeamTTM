function refresh_messages() {
  jQuery.ajax({
    type: 'GET',
    cache: false,
    url: '/get_messages',
    success: function(response){
      //alert(response);
      $('.bus_content').html('');
      var data = JSON.parse(response);
      for (var key in data) {
        $('#'+key).html(data[key]);
      }
    }
  });
}

function start_polling(){
  setInterval(function() {
    refresh_messages();
  }, 1000)
}
