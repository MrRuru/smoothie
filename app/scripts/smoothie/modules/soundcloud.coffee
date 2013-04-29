# A wrapper around the soundcloud api and the current user

define  ['soundcloudSdk', 'when'], \

        (SC, When) ->

  Soundcloud = ( () -> 

    # The track attributes used for the track models
    formatTrack = (track) ->
      {
        # The track attributes
        title: track.title,
        user_permalink: track.user.permalink_url,
        username: track.user.username,
        permalink_url: track.permalink_url,
        artwork_url: track.artwork_url && track.artwork_url.replace(/-large.jpg?.*$/, '-t500x500.jpg')
      }


    {

      # Authenticate the SDK
      # Should be handled internally in a souncloud callback
      initialize: (opts) ->        
        SC.accessToken(opts.accessToken) if opts.accessToken


      # Fetch and format a track
      fetchTrack: (track_id) ->
        deferred = When.defer()

        SC.get "/tracks/#{track_id}", (track) ->
          deferred.resolve( formatTrack(track) )

        deferred.promise

      # Gets the audio stream associated to a track
      getTrackStream: (track_id) ->
        deferred = When.defer()

        SC.stream "/tracks/#{track_id}", (player) ->
          deferred.resolve( player )

        deferred.promise

    }

  )()
