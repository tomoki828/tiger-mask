$(function() {

  $('.cart__footer__link, .btn-default').hover(
    function() {
      $(this).animate({ 
        backgroundColor: 'rgba(100,100,100,0.6)'
      }, 200, 'linear' );
    },
    function() {
      $(this).animate({ 
        backgroundColor: 'rgb(100,100,100)'
      }, 0, 'linear' );
    }
  );

});