$(document).ready(function() {
  $('.interval-action').on('click', function(event) {
    event.preventDefault();
    $.ajax({
      url: "/fajrants",
      method: "post",
      contentType: 'application/json',
      data: JSON.stringify({
        user_id: $('.fajrant-row').data('id'),
        end_interval: $(this).data('interval'),
        description: 'asda'
      }),
      success: function() {
        window.location.reload();
      }
    });
  });

  $('.delay-fajrant').on('click', function() {
    event.preventDefault();
    $(this).hide();
    $(this).parent().find('.delay-interval').show();
  });

  $('.finish-fajrant').on('click', function() {
    event.preventDefault();
    $.ajax({
      url: "/fajrants/" + $(this).data('id'),
      method: "delete",
      contentType: 'application/json',
      data: JSON.stringify({ user_id: $('.fajrant-row').data('id') }),
      success: function() {
        console.log('delete')
        window.location.reload();
      }
    });
  });

  if ($('#countdown').length) {
    var countdownNumberEl = $('#countdown-number').get(0);
    var countdown = $('#countdown').data('timer');
    $('#countdown-number svg circle').css('animation', 'countdown ' + countdown + 's linear infinite forwards;');
    countdownNumberEl.textContent = countdown;
    var countdownInterval = setInterval(function() {
      countdown = --countdown <= 0 ? 0 : countdown;

      countdownNumberEl.textContent = countdown;

      if (countdown < 20) {
        $('#countdown-number').addClass('out');
      }
      if (countdown === 0) {
        clearInterval(countdownInterval);
      }
    }, 1000);
  }
  
});
