class TweetSerializer < ActiveModel::Serializer
  attributes :id, :text, :username

  def id
    object.data.id
  end

  def username
    object.data.user["screen_name"]
  end

  def text
    object.data.text
  end
end
