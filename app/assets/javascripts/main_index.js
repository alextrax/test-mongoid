$(function(){

  $( "#ask_button" ).click(function() {
    var content = $("#new_question textarea").val();

    if (content.replace(/[ \t\r\n]+/g,"").length == 0)
    {
      $("#new_question")[0].reset();
      $("#ask_button").notify("Your question is empty",  "warn"  );
      return;
    }

    var url = $("#new_question").attr('action');
    $.post(url, $("#new_question").serialize(), function(data) {
      $("#new_question")[0].reset();
      $("#ask_button").notify("Question Sent!",  "success"  );
    }, "json")
    .fail(function() {
      $("#new_question")[0].reset();
      $("#ask_button").notify("Failed",  "error"  );
    });
  });
});