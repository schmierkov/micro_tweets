require 'rails_helper'

RSpec.describe TweetService do
  let(:tweet_service) { TweetService.new }
  let(:client) { double :twitter_client }
  let(:fake_tweets) { [OpenStruct.new(id: 123), OpenStruct.new(id: 333)] }

  describe '#store_tweets_for' do
    it 'calls search on twitter client with correct params' do
      expect(tweet_service).to receive(:client).and_return(client)
      expect(client).to receive(:search).with('foobar -rt')
        .and_return(fake_tweets)

      expect do
        tweet_service.store_tweets_for('foobar')
      end.to change(Tweet, :count).by(2)
    end

    it 'does store tweet duplicates' do
      expect(tweet_service).to receive(:client).twice.and_return(client)
      expect(client).to receive(:search).twice.with('foobar -rt')
        .and_return(fake_tweets)

      expect do
        tweet_service.store_tweets_for('foobar')
        tweet_service.store_tweets_for('foobar')
      end.to change(Tweet, :count).by(2)
    end

    it 'returns nil if keyword is blank' do
      expect(tweet_service.store_tweets_for('')).to be_nil
    end
  end
end
