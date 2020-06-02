// メガメニュー表示の記述

$(function() {
  // ①マウスをボタンに乗せた際のイベントを設定
  $('#menu li').hover(function() {
    // ②乗せたボタンに連動したメガメニューをスライドで表示させる
    $(this).find('.header__right__menu__list__contents').stop().slideDown();
  // ③マウスをボタンから離した際のイベントを設定
  }, function() {
    // ④マウスを離したらメガメニューをスライドで非表示にする
    $(this).find('.header__right__menu__list__contents').stop().slideUp();
  });

  $('.header__right__user--name, .header__right__user--cart, .header__right__user--logout, .header__right__user--login, .header__right__user--new, .header__mini__right__user--cart, .header__mini__right__user--logout, .header__mini__right__user--login, .header__mini__right__user--new').hover(
    function() {
      $(this).animate({ 
        backgroundColor: 'rgba(240,240,240,0.6)'
      }, 200, 'linear' );
    },
    function() {
      $(this).animate({ 
        backgroundColor: 'black'
      }, 0, 'linear' );
    }
  );

});