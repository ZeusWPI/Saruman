$(document).on('ready turbo:load', function() {
  $('[data-increment]').on('click', function() {
    const button = $(this);
    const input = button.parent().parent().find('input[type=number]');
    const newVal = Math.max(
      parseInt(input.val()) + parseInt(button.data('increment')),
      input.attr('min')
    );
    input.val(newVal);

    if (input.data('warning')) {
      const tr = input.closest('.tr');
      const leftover = parseInt(tr.find('.leftover').val());
      if (newVal > leftover) {
        tr.addClass('alert');
      } else {
        tr.removeClass('alert');
      }
    }
  });
});
