# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  spotify_access_token  :string
#  spotify_name          :string
#  spotify_refresh_token :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  spotify_id            :string
#
class User < ApplicationRecord
  def spotify_accessible?
    return false if self.spotify_access_token.nil?
    return false if self.spotify_refresh_token.nil?

    true
  end

  # https://github.com/guilhermesad/rspotify
  def spotify_user
    RSpotify::User.new(
      {
        'credentials' => {
          "token" => self.spotify_access_token,
          "refresh_token" => self.spotify_refresh_token,
          "access_refresh_callback" =>
            Proc.new { |new_access_token, token_lifetime |
              now = Time.now.utc.to_i
              deadline = now+token_lifetime
              self.save_new_access_token(new_access_token)
            }
        },
        'id' => self.spotify_id
      }
    )
  end

  # https://developer.spotify.com/documentation/web-api/reference/get-users-top-artists-and-tracks
  def top_artists
    spotify_user.top_artists
  end

  # https://developer.spotify.com/documentation/web-api/reference/get-users-top-artists-and-tracks
  def top_tracks
    spotify_user.top_tracks
  end

  # https://developer.spotify.com/documentation/web-api/reference/get-followed
  def following_artists
    spotify_user.following(type: 'artist')
  end
end
