class Tweet < ActiveRecord::Base
  def data
    OpenStruct.new(JSON.parse(json_payload))
  end
end
