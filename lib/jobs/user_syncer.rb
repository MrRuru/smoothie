require 'worker'

module Smoothie::Jobs

  class UserLikesSyncer

    DEFAULT_DELAY = 86400 # 1 day
    MAX_DELAY = 2592000 # 1 month
    LIKE_THRESHOLD = 200

    class << self

      # Only static methods
      def run(user_id)

        base_key = "smoothie:jobs:user_syncer:#{user_id}:"
        sync_key = base_key + "sync"
        likes_key = base_key + "likes"
        delay_key = base_key + "delay"

        # Check if already synced
        return if $redis.exists sync_key

        # Get the attrs on soundcloud
        user, likes = $soundcloud.get_user(user_id)

        # TODO : Save it on neo4j (user + likes)
        # Favorites return also data, no need(?) for first sync

        # Check the likes delta for the next sync
        former_likes = $redis.get(likes_key).to_i
        former_delay = $redis.get(delay_key).to_i
        next_delay = get_next_delay(former_delay, former_likes, user.public_favorites_count)
        $redis.set likes_key, user.public_favorites_count
        $redis.set delay_key, next_delay

        # Set the synced flag
        $redis.set sync_key, Time.new.to_i
        $redis.expire sync_key, next_delay

        # Enqueue the likes
        likes.each do |track_id|
          Smoothie::Jobs::Worker.enqueue :track, track_id
        end

      end


      def get_next_delay(former_delay, former_likes, new_likes)

        return DEFAULT_DELAY unless former_likes != 0 && former_delay != 0

        likes_delta = new_likes - former_likes

        # Losing likes?! => let him sleep longer
        if (likes_delta <= 0)
          next_delay = (former_delay * 1.5).round
        else
          # Calculate the optimal delay (assume constant growth)
          next_delay = ( former_delay * LIKE_THRESHOLD / likes_delta ).to_i
        end

        next_delay = MAX_DELAY if next_delay > MAX_DELAY
        return next_delay

      end

    end

  end

end