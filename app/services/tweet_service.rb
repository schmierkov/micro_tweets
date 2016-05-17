class TweetService
  def store_tweets_for(keyword)
    return if keyword.blank?

    tweets = client.search("#{keyword} -rt", result_type: "recent").take(100)
    tweets.each do |client_tweet|
      Tweet.find_or_create_by(tweet_id: client_tweet.id) do |tweet|
        tweet.keyword = keyword
        tweet.json_payload = client_tweet.attrs.to_json
      end
    end
  end

  private

  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
    end
  end
end
