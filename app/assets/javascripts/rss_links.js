$(document).ready(function(){
  $("#rss_link_url").bind("paste", function(){
    setTimeout(function() {
     $("#rss_link_url").trigger("blur");
    }, 50);
  });

  $("#rss_link_url").blur(function(){
    if($(this).val() != ""){
      $("#rss_link_home_url, #rss_link_description, #rss_link_title").attr("disabled", "");
      $("#rss_link_home_url, #rss_link_description, #rss_link_title").val("");
      $(".rssLoader").show();
      $.ajax({
        type: "GET",
        url: "/rss_links/1/check",
        data: {"url" : $(this).val()},
        //contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(result) {
          $("#rss_link_title").val(result['title']);
          $("#rss_link_description").val(result['description']);
          $("#rss_link_home_url").val(result['home_url']);
          $("#rss_link_home_url, #rss_link_description, #rss_link_title").removeAttr("disabled");
        },
        error: function(){
          alert("Unable to parse the Rss URL");
        },
        complete: function(){
          $(".rssLoader").hide();
        }
      });
    }
  });
});

$(document).on('click', "span.token a", function(){
  var rss_link_id = $("h1:first").attr("rss-link-id");
  var list_id = $(this).parent().attr("list-id");
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
        $("table#lists").append("<tr list-id='"+list_id+"' title='"+title+"'><td>"+name+"</td><td><a href='javascript:void(0)'>Add</a></td></tr>")
      }
      else
        $(this).parent().show();
    }
  });
});

$(document).on('click', "table#lists a", function(){
  var rss_link_id = $("h1:first").attr("rss-link-id");
  var list_id = $(this).parents("tr:first").attr("list-id");
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
        $("div#listTokens").append("<span class='token' list-id='"+list_id+"' title='"+title+"'>"+name+"<a href='javascript: void(0)'>x</a></span>")
      }
      else
        $(this).parents("tr:first").show();
    }
  });
});