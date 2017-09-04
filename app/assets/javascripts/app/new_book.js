$(document).ready(function() {
  $('#newlibrary').hide();
  $('#addlibrary').click(function(event){
    event.preventDefault();
    $('#newlibrary').toggle();
  });

  $('#bookdetails').hide();
  $('#morebookdetails').click(function(event){
    event.preventDefault();
    $('#bookdetails').toggle();
  });
});

