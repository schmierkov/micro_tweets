class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :tweet_id
      t.string :keyword
      t.text :json_payload

      t.timestamps null: false
    end
  end
end
