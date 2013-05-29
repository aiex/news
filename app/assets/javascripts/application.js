//= require jquery
//= require jquery_ujs
//= require bootstrap/bootstrap-alert
//= require bootstrap/bootstrap-button
//= require bootstrap/bootstrap-dropdown
//= require timeago
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