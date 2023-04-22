$(document).on('ready turbo:load', function() {
  $(document).on("click", ".btn-disapprove", function(e) {
    e.preventDefault();

    const _self = $(this);
    $("#disapprove-id").val(_self.data('id'));

    $(_self.attr('href')).modal('show');
  });
});
