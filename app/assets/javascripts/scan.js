$(document).on('ready turbo:load', function() {
  $(".btn-action").click(function() {
    $(".btn-action").removeClass("btn-primary").addClass("btn-default");
    $(this).addClass("btn-primary");
  });
});
