require 'rails_helper'

describe TweetService do
  let(:tweet_service) { TweetService.new }
  let(:client) { double :twitter_client }

  describe '#get_tweets_for' do
    it 'calls search on twitter client with correct params' do
      expect(tweet_service).to receive(:client).and_return(client)
      expect(client).to receive(:search).with("#foobar -rt")

      tweet_service.get_tweets_for("foobar")
    end

    it 'does not call search with blank params' do
      expect(tweet_service.get_tweets_for("")).to be_nil
    end
  end
end
