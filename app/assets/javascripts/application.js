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
//= require bootstrap/bootstrap-alert
//= require bootstrap/bootstrap-button
//= require bootstrap/bootstrap-dropdown
//= require timeago
$(document).ready(function() {
  $("abbr.timeago").timeago();
});
$(document).on('click', ".pagination ul li:not(.active) a", function(){
  $(".pagination ul li").addClass("disabled");
});
//cls => alert-success, alert-info, alert-error
function displayFlash(msg, cls, strong){
  var content = "<div class='alert " + (cls!= undefined ? cls : '') +"'> " + (strong ? '<strong>' : '') + msg + (strong ? '</strong>' : '') + "<a class='close' data-dismiss='alert' href='#'>×</a>      </div>";
  $("div.container:eq(1) .alert:first").remove();
  $("div.container:eq(1)").prepend(content);
}
function toggleDoms(show, hide){
  $(show).show();
  $(hide).hide();
}