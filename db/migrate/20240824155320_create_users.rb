class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :spotify_name
      t.string :spotify_id
      t.string :spotify_access_token
      t.string :spotify_refresh_token
      t.timestamps
    end
  end
end
