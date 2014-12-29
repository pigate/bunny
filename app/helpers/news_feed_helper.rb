module NewsFeedHelper
  def except_feed_push(member_id, str, except_id)
    @member = Member.find(member_id)
    @member.followers.each do |m|
      if (m.id != except_id)
      #check if can update log
        updates = str + m.news_feed.updates
        m.news_feed.update_attributes(:updates => updates)
      end
    end
  end
  
  def mass_feed_push(member_id, str, possessive_str=nil)
   @member = Member.find(member_id)
    @member.followers.each do |m|
      #check if can update log
        updates = m.news_feed.updates
        m.news_feed.update_attributes(:updates => updates + str)
    end
  end
  
  def single_feed_push(target_member_id, str)
    m_news_feed = NewsFeed.find_by_member_id(target_member_id)
    updates = m_news_feed.updates
    m_news_feed.update_attributes("updates" => str + updates)
  end

end

