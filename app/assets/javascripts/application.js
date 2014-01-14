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
//= require notify
//= require jquery.autosize

var faye;

function change_title() {
  var question_notifications_count = (parseInt($("#question_notifications_counter").text()) || 0);
  var answer_notifications_count = (parseInt($("#answer_notifications_counter").text()) || 0);
  var total_count = question_notifications_count + answer_notifications_count;
  document.title = (total_count != 0 ? "(" + total_count + ")" : "") + "FastQ";
}

function increase_counter(id) {
  var count = (parseInt($("#" + id).text()) || 0) + 1;
  $("#" + id).text(count);
  change_title();
}

function handle_notification(notification) {

  if (notification.type == "q")
  {
    $("#question_notifications_list li.dropdown-header").after('<li role="presentation"><a role="menuitem" tabindex="-1" href="' + notification.url + '"data-method="delete">' + notification.question_description + '</a></li>');
    increase_counter("question_notifications_counter");
  }
  else if(notification.type == "a")
  {
    $("#answer_notifications_list li.dropdown-header").after('<li role="presentation"><a role="menuitem" tabindex="-1" href="' + notification.url + '"data-method="delete">' + notification.question_description + '</a></li>');
    increase_counter("answer_notifications_counter");
  }
  else if (notification.type == "s") {
      faye.subscribe(notification.channel, function (data) {
        handle_notification(JSON.parse(data)) 
      });
  }
}

function subscribe_channels(channels) {
  for (var index in channels)
  {
    faye.subscribe(channels[index], function (data) {
      handle_notification(JSON.parse(data)) 
    });
  }
}

function init_notifications() {
  for (var index in window.notification_objects)
  {
    handle_notification(window.notification_objects[index])
  }
}

$(function() {
  if ($('#alert_text').text().trim().length == 0)
  {
    $("#alert_text").hide();
  }

  $('textarea.autoresize').autosize();

  faye = new Faye.Client('http://' + window.faye_server_domain_name + ':' + window.faye_server_port + '/faye');
  
  subscribe_channels(window.channels);
  init_notifications();
});