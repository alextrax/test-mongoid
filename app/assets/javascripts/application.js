// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .

var faye;

function handle_notification(notification) {
  if (notification.type == "q") {
    $("#question_notifications_list").prepend('<li role="presentation"><a role="menuitem" tabindex="-1" href="' + notification.url + '"data-method="delete">Some one asked...</a></li>')
    var count = parseInt($("#question_notifications_counter")[0].text.match(/\d+/g)[0]) + 1;
    $("#question_notifications_counter").text('Questions(' + count + ')');
  }
  else if (notification.type == "a") {
    $("#answer_notifications_list").prepend('<li role="presentation"><a role="menuitem" tabindex="-1" href="' + notification.url + '"data-method="delete">Some one answered...</a></li>')
    var count = parseInt($("#answer_notifications_counter")[0].text.match(/\d+/g)[0]) + 1;
    $("#answer_notifications_counter").text('Answers(' + count + ')');
  }
  else if (notification.type == "s") {
      faye.subscribe(notification.channel, function (data) {
        handle_notification(JSON.parse(data)) 
      });
  }
}

function subscribe_channels(channels) {
  if (channels.user)
  {
    faye.subscribe(channels.user, function (data) {
      handle_notification(JSON.parse(data)) 
    });
  }

  if (channels.questions)
  {
    for (var index in channels.questions)
    {
      faye.subscribe(channels.questions[index], function (data) {
        handle_notification(JSON.parse(data)) 
      });
    }
  }
}

function get_channels() {
  $.ajax({
    url: "/channels",
    type: "GET",
    dataType: "json",
    success: function(json_obj) {
      subscribe_channels(json_obj);
    }
  });
}

$(function() {
  faye = new Faye.Client('http://localhost:9292/faye');
  /*
  var user_id = $('#user_id')[0].value;
  faye.subscribe('/notifications/users/' + user_id, function (data) {
    alert(data);
  });
  */
  get_channels();
});