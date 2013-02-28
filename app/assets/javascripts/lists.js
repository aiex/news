$(document).on('click', "span.token a", function(){
  var list_id = $("h1:first").attr("list-id");
  var rss_link_id = $(this).parent().attr("rss-id");
  var name = $(this).parent().text().replace("x", "");
  var title = $(this).parent().attr("title");
  $(this).parent().hide();
  $.ajax({
    url: "/manage_rss_list/" + list_id + "/" + rss_link_id + "?flag=0",
    dataType: 'json',
    type: "PUT",
    success: function(response){
      if(response){
        $(this).parent().remove();
        $("table#rssLinks").append("<tr rss-id='"+rss_link_id+"' title='"+title+"'><td>"+name+"</td><td><a href='javascript:void(0)'>Add</a></td></tr>")
      }
      else
        $(this).parent().show();
    }
  });
});

$(document).on('click', "table#rssLinks a", function(){
  var list_id = $("h1:first").attr("list-id");
  var rss_link_id = $(this).parents("tr:first").attr("rss-id");
  var name = $(this).parent().prev().html();
  var title = $(this).parents("tr:first").attr("title");
  $(this).parents("tr:first").hide();
  $.ajax({
    url: "/manage_rss_list/" + list_id + "/" + rss_link_id + "?flag=1",
    dataType: 'json',
    type: "PUT",
    success: function(response){
      if(response){
        $(this).parents("tr:first").remove();
        $("div#rssTokens").append("<span class='token' rss-id='"+rss_link_id+"' title='"+title+"'>"+name+"<a href='javascript: void(0)'>x</a></span>")
      }
      else
        $(this).parents("tr:first").show();
    }
  });
});
