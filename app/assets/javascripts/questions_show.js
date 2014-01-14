
$(function(){

  $( "#answer_button" ).click(function() {
    var content = $("#new_answer textarea").val();

    if (content.replace(/[ \t\r\n]+/g,"").length == 0)
    {
      $("#new_answer")[0].reset();
      $("#new_answer textarea").notify("Your answer is empty", {className:"warn", position:"top center" });
      return;
    }

    $(".btn").attr("disabled", "disabled");
    $("#answer_content").attr("readonly", "readonly");

    var url = $("#new_answer").attr('action');
    $.post(url, $("#new_answer").serialize(), function(data) {
      $("#answer_list").append('<li class="list-group-item"><ul><li>' + content + '</li></ul></li>');
      $("#new_answer")[0].reset();
      $("#answer_button").notify("Answered", {className:"success"});
      setTimeout('self.location="/"', 1000)
    }, "json")
    .fail(function() {
      $("#new_answer")[0].reset();
      $("#answer_button").notify("Failed", {className:"error"});
      $(".btn").attr("disabled", false);
      $("#answer_content").attr("readonly", false);
    });
  });

  $( "#follow_button" ).click(function() {

    $(".btn").attr("disabled", "disabled");
    $("#answer_content").attr("readonly", "readonly");

    var url = $("#new_follower").attr('action');
    $.post(url, $("#new_follower").serialize(), function(data) {
      $("#follow_button").notify("You are now following this question", {className:"success"});
      setTimeout('self.location="/"', 1000)
    })
    .fail(function() {
      $("#follow_button").notify("Failed", {className:"error"});
      $(".btn").attr("disabled", false);
      $("#answer_content").attr("readonly", false);
    });
  });

});