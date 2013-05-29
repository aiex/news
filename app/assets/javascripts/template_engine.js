function generateNewsFeedHtml(feeds){
  var news_feed_html='';
  $.each(feeds, function(index, feed){
    news_feed_html += "<div class='newsFeed new' id='nf"+ feed['id'] +"'>"
    if(feed['image_urls'].length > 0)
    news_feed_html += "<div class='newsImage'><img src='"+ feed['image_urls'][0] +"' /></div>";
    news_feed_html += '<div class="newsTitle">';
    news_feed_html += "<a href="+ feed['link'] +" target='_blank'> "+ feed['title'] +"</a> </div>";
    // news_feed_html += "<a> href='"+ feed['link'] +"' target='_blank'> "+ feed['title'] +"</a> - "; ASSOCIATION OBJECTS WILL SEE INTO IT AFTERWORDS
    // <a href="http://feeds.feedburner.com/NdtvNews-TopStories" target="blank">NDTV News - Top Stories</a>
    news_feed_html += "<div class='newsDescription'>" + feed['description'] + "</div>";
    news_feed_html += "<div class='timeAgo'><abbr class='timeago' title='"+ feed['published_date'] +"'>"+ feed['published_date'] +"</abbr></div><div class='clearfix'></div></div>";
  });
  return news_feed_html;
}
function generateListHtml(lists){
  var lists_html = '';
  $.each(lists, function(index, list){
    lists_html += "<h3><a href='/lists/"+ list['id'] +"/news_feeds'>"+ list['name'] +"</a></h3>"
  });
  return lists_html;
}