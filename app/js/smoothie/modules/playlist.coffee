Smoothie.Modules.Playlist = {
  # Mockup data
  tracks: [
      {
        artwork: 'https://i4.sndcdn.com/artworks-000034170195-wb7buo-t500x500.jpg',
        title: 'Mammals - Move Slower Feat. Flash Forest (FREE D/L in description)',
        url: 'http://www.google.com',
        uploader_name: 'Flash Forest',
        uploader_url: 'http://www.google.com'
      },
      {
        artwork: 'https://i4.sndcdn.com/artworks-000037931943-gkafnb-t500x500.jpg',
        title: 'Sir Sly - Gold',
        url: 'http://www.google.com',
        uploader_name: 'Sir Sly',
        uploader_url: 'http://www.google.com'
      },
      {
        artwork: 'https://i1.sndcdn.com/artworks-000033642979-p06mxq-t500x500.jpg',
        title: 'The Temper Trap - Sweet Disposition (RAC Mix)',
        url: 'http://www.google.com',
        uploader_name: 'RAC',
        uploader_url: 'http://www.google.com'
      }
  ]

  # The current track index
  index: 1

  # Change tracks
  next: () ->
    console.log "Playlist#next"
    @index += 1
    Smoothie.Views.PlayerView.moveTracksForward()

  previous: () ->
    console.log "Playlist#previous"
    @index -= 1
    Smoothie.Views.PlayerView.moveTracksBackward()

  # Get tracks
  getPreviousTrack: () ->
    @tracks[@index - 1]

  getCurrentTrack: () ->
    @tracks[@index]

  getNextTrack: () ->
    @tracks[@index + 1]
}
