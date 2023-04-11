$(document).on('turbolinks:load', function() {
  // Fancy fields
  const datePickerOptions = {
    autoclose: true,
    weekStart: 1,
    language: 'nl',
    startDate: $.format.date(Date(), "yyyy-MM-dd HH:mm")
  };

  $('#deadline').datetimepicker(datePickerOptions);
});

