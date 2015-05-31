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
