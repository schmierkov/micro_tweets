class Api::V1::TweetsController < ApplicationController
  respond_to :json

  skip_before_action :verify_authenticity_token
  skip_before_filter :authenticate_user!

  def index
    if Tweet::KEYWORDS.include?(keyword)
      respond_to do |format|
        # TODO: replace db call with ElasticSearch backend
        format.json { render json: Tweet.where(keyword: keyword).last(10) }
      end
    else
      respond_to do |format|
        format.json { render json: {tweets: []}, status: :not_found }
      end
    end
  end

  private

  def keyword
    params[:keyword] || ""
  end
end
