require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe '#data' do
    let(:payload) { File.read(Rails.root.join("spec/support/tweet.json")) }
    let(:tweet) { Tweet.new(json_payload: payload) }

    it 'returns correct object from provided json string' do
      expect(tweet.data.text).to include('#healthcare')
    end

    context 'has corrupt json payload' do
      let(:payload) { '{"thisfile": "corruptis' }

      it 'raises JSON parsing error with corrupt json_payload' do
        expect do
          tweet.data
        end.to raise_error(JSON::ParserError)
      end
    end
  end
end
