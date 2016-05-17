namespace :twitter do
  desc "Imports tweets for 'healthcare', 'nasa' and 'open source'"
  task import: :environment do
    Tweet::KEYWORDS.each do |search_term|
      TweetService.new.store_tweets_for(search_term)
    end
  end
end
