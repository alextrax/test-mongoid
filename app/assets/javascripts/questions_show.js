
$(function(){

  $( "#answer_button" ).click(function() {
    var url = $("#new_answer").attr('action');
    $.post(url, $("#new_answer").serialize(), function(data) {
      var content = $("#new_answer textarea").val();
      $("#answer_list").append('<li class="list-group-item"><ul><li>' + content + '</li></ul></li>');
      $("#new_answer")[0].reset();
      $("#answer_button").notify("Answered",  "success"  );
    });
  });

  $( "#follow_button" ).click(function() {
    var url = $("#new_follower").attr('action');
    $.post(url, $("#new_follower").serialize(), function(data) {
      $("#follow_button").notify("You are now following this question",  "success"  );
    });
  });

});