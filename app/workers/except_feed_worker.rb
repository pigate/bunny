require 'sidekiq'
class ExceptFeedWorker
  include Sidekiq::Worker

  def perform(member_id, str, except_id)
    puts("ExceptFeedWorker start")
    @member = Member.find(member_id)
   #Rails.logger.debug("ExceptFeedWorker task: User(#{@member.id}), followers count(#{@member.followers.count})")
    @member.followers.each do |m|
      if (m.id != except_id)
      #check if can update log
        updates = str + m.news_feed.updates
        m.news_feed.update_attributes(:updates => updates)
        puts("ExceptFeedWorker task: User(#{m.id})-- updates: #{str}")
      end
    end
    puts("ExceptFeedWorker/Recipe Creation END")
  end
end



