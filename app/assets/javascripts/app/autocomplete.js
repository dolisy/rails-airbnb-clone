document.addEventListener("DOMContentLoaded", function() {
  var location = document.getElementById('geo-location');

  if (location) {
    var autocomplete = new google.maps.places.Autocomplete(location, { types: ['geocode'] });
    // google.maps.event.addListener(autocomplete, 'place_changed', function(){
    //   console.log(this.getPlace());
    // });
    google.maps.event.addDomListener(location, 'keydown', function(e) {
      if (e.key === "Enter") {
        e.preventDefault(); // Do not submit the form on Enter.
      }
    });
  }
});


document.addEventListener("DOMContentLoaded", function() {
  var address = document.getElementById('geo-address');

  if (location) {
    var autocomplete = new google.maps.places.Autocomplete(address, { types: ['geocode'] });
    // google.maps.event.addListener(autocomplete, 'place_changed', function(){
    //   console.log(this.getPlace());
    // });
    google.maps.event.addDomListener(address, 'keydown', function(e) {
      if (e.key === "Enter") {
        e.preventDefault(); // Do not submit the form on Enter.
      }
    });
  }
});
