require 'sidekiq'
class MassFeedWorker
  include Sidekiq::Worker

  def perform(member_id, str, possessive_str=nil)
    Rails.logger.debug("MassFeedWorker/Recipe Creation start")
    @member = Member.find(member_id)
    i = 0
   #Rails.logger.debug("MassFeedWorker task: User(#{@member.id}), followers count(#{@member.followers.count})")
    @member.followers.each do |m|
      #check if can update log
        updates = str + m.news_feed.updates
        m.news_feed.update_attributes(:updates => updates)
        Rails.logger.debug("MassFeedWorker task: User(#{m.id})-- updates: #{updates + str}")
    end
    Rails.logger.debug("MassFeedWorker/Recipe Creation END")
  end
end



