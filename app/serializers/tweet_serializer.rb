class TweetSerializer < ActiveModel::Serializer
  attributes :id, :text, :username, :name

  def id
    object.data.id
  end

  def name
    object.data.user["name"]
  end

  def username
    object.data.user["screen_name"]
  end

  def text
    object.data.text
  end
end
