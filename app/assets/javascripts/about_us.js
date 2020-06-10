$(function() {
  let addContent = function(){
    $('.aboutus__content--right').animate({ 
      opacity: '1'
        }, 400, 'linear' );
  }

  $(window).on('load', function(){

    // $('.aboutus__content--left').animate({ 
    //   opacity: '1'
    //     }, 400, 'linear' );
    // $('.aboutus__layer--1').addClass('is-active');
    // setTimeout(addContent, 1500);
    $('.aboutus__layer--2').addClass('is-active');
  });
});