//= require template_engine
$(document).ready(function(){
  $(".new").removeClass("new");
  if($("#moreNews a").length == 0)
    $("#moreNews").remove();
  $(window).scroll(function() {
    if($("#moreNews a").length > 0) {
      var scrollCenter = $(window).height() - 25;
      var workOffsetTop = $("#moreNews").offset().top - $(document).scrollTop();
      var workOffsetBot = workOffsetTop + 16;
      if ((workOffsetBot > scrollCenter) || (workOffsetTop > scrollCenter))
        ;
      else {
        $("#moreNews").find("a").trigger("click");
        $("#moreNews").find("a").remove();
      }
    }
  });
  generatePageContent();
});

function generatePageContent() {
  var more_link = $(".dashboard #moreNews").clone();
  $(".dashboard #moreNews").remove();
  var news_feeds_html = generateNewsFeedHtml(news_feeds);
  $("div.dashboard").append(news_feeds_html);
  $("div.dashboard").append(more_link);
  $("abbr.timeago").timeago();
  var lists_html = generateListHtml(lists);
  $("div.lists").append(lists_html);
  $("#moreNews").show();
  setTimeout(function(){ $(".new").removeClass("new"); }, 500);
}
