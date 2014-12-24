Member.all.each do |u|
  if (u.news_feed == nil)
    u.news_feed = NewsFeed.create!(:member_id => u.id)
  else
    u.news_feed.update_attributes(:updates => "")
  end
end
