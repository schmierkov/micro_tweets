require 'rails_helper'

RSpec.describe Api::V1::TweetsController, type: :controller do
  render_views

  let(:json_response) { JSON.parse(response.body) }

  describe '#index' do
    context 'with stubbed twitter requests' do
      before do
        stub_request(:get, "https://api.twitter.com/1.1/search/tweets.json?count=100&q=#{URI.encode(keyword.downcase)}%20-rt&result_type=recent")
          .to_return(status: 200, body: "{}", headers: {})
      end

      it_behaves_like 'successful index call with empty payload' do
        let(:keyword) { 'healthcare' }
      end

      it_behaves_like 'successful index call with empty payload' do
        let(:keyword) { 'NASA' }
      end

      it_behaves_like 'successful index call with empty payload' do
        let(:keyword) { 'Open Source' }
      end
    end

    it 'returns not found if keyword is not permitted' do
      get :index, keyword: 'Unknown Keyword', format: :json

      expect(response.status).to eq(404)
      expect(json_response).to eq({"tweets"=>[]})
    end

    context 'with keyword "healthcare"' do
      let(:keyword) { 'healthcare' }

      context "twitter returns internal server error" do
        let(:expected_log_message) do
          "Error during import: Twitter::Error::InternalServerError"
        end
        
        before do
          stub_request(:get, "https://api.twitter.com/1.1/search/tweets.json?count=100&q=#{URI.encode(keyword.downcase)}%20-rt&result_type=recent")
            .to_return(status: 500, body: "{}", headers: {})
        end

        it 'does not break' do
          expect(Rails.logger).to receive(:error).with(expected_log_message)

          get :index, keyword: keyword, format: :json

          expect(response.status).to eq(200)
          expect(json_response).to eq({"tweets"=>[]})
        end
      end

      context 'with tweets' do
        let(:json_payload) do
          File.read(Rails.root.join("spec/support/tweet.json"))
        end
        let!(:tweet_1) do
          Tweet.create(keyword: 'healthcare', json_payload: json_payload)
        end
        let!(:tweet_2) do
          Tweet.create(keyword: 'healthcare', json_payload: json_payload)
        end
        let!(:tweet_3) do
          Tweet.create(keyword: 'nasa', json_payload: json_payload)
        end

        it 'returns json with tweets' do
          get :index, keyword: 'healthcare', format: :json

          expect(response.status).to eq(200)
          expect(json_response['tweets'].size).to eq(2)

          expect(json_response['tweets'].first).to have_key('id')
          expect(json_response['tweets'].first).to have_key('text')
          expect(json_response['tweets'].first).to have_key('username')
          expect(json_response['tweets'].first).to have_key('name')
        end
      end
    end
  end
end
