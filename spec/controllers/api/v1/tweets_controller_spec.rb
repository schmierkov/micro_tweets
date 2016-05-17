require 'rails_helper'

RSpec.describe Api::V1::TweetsController, type: :controller do
  render_views

  let(:json_response) { JSON.parse(response.body) }

  describe '#index' do
    it 'is successful for healthcare' do
      get :index, keyword: 'healthcare', format: :json

      expect(response.status).to eq(200)
      expect(json_response).to eq({"tweets"=>[]})
    end

    it 'is successful for nasa' do
      get :index, keyword: 'nasa', format: :json

      expect(response.status).to eq(200)
      expect(json_response).to eq({"tweets"=>[]})
    end

    it 'is successful for open source' do
      get :index, keyword: 'open source', format: :json

      expect(response.status).to eq(200)
      expect(json_response).to eq({"tweets"=>[]})
    end

    it 'is successful for unknown keyword' do
      get :index, keyword: 'unknown keyword', format: :json

      expect(response.status).to eq(404)
      expect(json_response).to eq({"tweets"=>[]})
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
      end
    end
  end
end
