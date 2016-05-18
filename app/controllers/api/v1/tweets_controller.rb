class Api::V1::TweetsController < ApplicationController
  respond_to :json

  skip_before_action :verify_authenticity_token

  def index
    if Tweet::KEYWORDS.include?(keyword)
      # TODO: replace this logic by background worker that runs every ~5 min.
      if tweets.empty?
        TweetService.new.store_tweets_for(keyword)
      end

      respond_to do |format|
        # TODO: replace db call with ElasticSearch backend
        format.json { render json: tweets.last(10) }
      end
    else
      respond_to do |format|
        format.json { render json: {tweets: []}, status: :not_found }
      end
    end
  end

  private

  def keyword
    (params[:keyword] || "").downcase
  end

  def tweets
    Tweet.where(keyword: keyword, created_at: Time.now-5.minutes..Time.now)
  end
end
