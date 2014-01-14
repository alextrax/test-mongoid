$(function(){

  $( "#ask_button" ).click(function() {
    var content = $("#new_question textarea").val();

    if (content.replace(/[ \t\r\n]+/g,"").length == 0)
    {
      $("#new_question")[0].reset();
      $("#new_question textarea").notify("Your question is empty", {className:"warn", position:"top center" });
      return;
    }

    var url = $("#new_question").attr('action');
    $.post(url, $("#new_question").serialize(), function(data) {
      $("#new_question")[0].reset();
      $("#ask_button").notify("Question Sent!", {className:"success"});
    }, "json")
    .fail(function() {
      $("#new_question")[0].reset();
      $("#ask_button").notify("Failed", {className:"error"});
    });
  });
});