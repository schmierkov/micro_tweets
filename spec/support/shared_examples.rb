RSpec.shared_examples "successful index call with empty payload" do |parameter|
  it 'is successful' do
    get :index, keyword: keyword, format: :json

    expect(response.status).to eq(200)
    expect(json_response).to eq({"tweets"=>[]})
  end
end
