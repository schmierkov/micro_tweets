class Tweet < ActiveRecord::Base
  KEYWORDS = ['healthcare', 'nasa', 'open source'].freeze

  def data
    OpenStruct.new(JSON.parse(json_payload))
  end
end
