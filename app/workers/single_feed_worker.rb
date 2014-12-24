require 'sidekiq'


#used to send update to newsfeed of only single target member

#used for hearts ("likes"), comments on a convo... that belongs to a post or recipe, creation of a rating on a recipe, following a user, a member joining a group

class SingleFeedWorker
  include Sidekiq::Worker

  def perform(target_member_id, str)
    puts("SingleFeedWorker start for User(#{target_member_id})")
    m_news_feed = NewsFeed.find_by_member_id(target_member_id)
    updates = m_news_feed.updates
    m_news_feed.update_attributes("updates" => str + updates)
    puts("SingleFeedWorker end for User(#{target_member_id})")
  end
end
