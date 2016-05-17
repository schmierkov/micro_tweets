require "rails_helper"

RSpec.describe 'Tweet Api Call', type: :request do
  let(:json_payload) do
    File.read(Rails.root.join("spec/support/tweet.json"))
  end
  let!(:tweet_1) do
    Tweet.create(keyword: 'healthcare', json_payload: json_payload)
  end
  let!(:tweet_2) do
    Tweet.create(keyword: 'nasa', json_payload: json_payload)
  end
  let(:json_response) { JSON.parse(response.body) }

  it 'calls api path without keyword param' do
    get "/api/v1/tweets.json"

    expect(response.status).to eq(404)
    expect(response.body).to eq("{\"tweets\":[]}")
  end

  it 'calls api path with camelcase keyword param' do
    get "/api/v1/tweets.json?keyword=HealthCare"

    expect(response.status).to eq(200)
    expect(json_response['tweets'].size).to eq(1)
    expect(json_response['tweets'].first['text']).to eq(tweet_1.data.text)
  end
end
