$(document).ready(function() {
  $("[role='auto-submit-file']").change(function() {
    $(this).parents("form").submit();
  });
});
