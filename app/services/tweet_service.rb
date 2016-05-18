class TweetService
  def store_tweets_for(keyword)
    return unless Tweet::KEYWORDS.include?(keyword)

    Rails.logger.info "Starting tweet import for: #{keyword}"
    begin
      tweets = client.search("#{keyword} -rt", result_type: "recent").take(100)
    rescue *Twitter::Error.errors.values => e
      # TODO: try to limit exceptions to be rescued
      Rails.logger.error "Error during import: #{e}"
      tweets = []
    end

    tweets.each do |client_tweet|
      Tweet.find_or_create_by(tweet_id: client_tweet.id) do |tweet|
        tweet.keyword = keyword
        tweet.json_payload = client_tweet.attrs.to_json
      end
    end
    Rails.logger.info "Import done."
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
