// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.tokeninput
//= require bootstrap
//= require cocoon
//= require video
//= require owl.carousel
//= require_tree .


// Flash fallback of video.js
videojs.options.flash.swf = "/assets/swf/video-js.swf";

$(document).ready(function() {

  // Initialize token inputs for user profile page
  $("#user_focus_tokens").tokenInput("/api/focuses.json", {
    searchingText: 'Searching...',
    minChars: 1,
    preventDuplicates: true,
    prePopulate: $('#user_focus_tokens').data('pre'),
    theme: "visual-country",
  });

  // Manually set posters for mobile since Video.js doesn't automagically
  $('[data-videojs-thumbnail]').each(function(index, element) {
    var $id     = $(element).attr('id'),
        $poster = $(element).data('videojs-thumbnail'),
        player  = videojs($id);

    player.poster($poster);
  });
$(document).ready(function() {

  var owl = $(".carousel .carousel__main");

  owl.owlCarousel({

      pagination: false,

      itemsCustom : [
        [0, 0],
        [240, 0],
        [580, 2],
        [920, 3],
        [1260, 4],
        [1600, 5]
      ],
  });

  // Custom Navigation Events
  $(".carousel__navigation__next").click(function(){
    owl.trigger('owl.next');
  })
  $(".carousel__navigation__prev").click(function(){
    owl.trigger('owl.prev');
  })


});
});
