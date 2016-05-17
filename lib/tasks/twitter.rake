namespace :twitter do
  desc "Imports tweets for 'healtcare', 'nasa' and 'open source'"
  task import: :environment do
    ['healthcare', 'nasa', 'open source'].each do |search_term|
      TweetService.new.store_tweets_for(search_term)
    end
  end
end
