$(document).on('turbolinks:load', function() {
  $('#new_scan').submit(function(e) {
    const tr = $('.tr.alert');
    if (tr.length > 0) {
      confirm("Some of these items are not within limits. Are you sure you want to continue?");
    } else {
      true;
    }
  });
});
