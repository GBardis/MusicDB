class ArtistsController < ApplicationController
  before_action do
    @discogs = Discogs::Wrapper.new('Test OAuth', user_token: 'uUAcpNNqtCmvrLITnpzKeuxfUcxsQdeGRJRggXqq')
  end
  before_action do
    RSpotify.authenticate('11180b801be74a9a9181777e6f78d5d9', '0e4a3494142b4b24b01f487b3ae6631d')
  end

  def show
    @artist = Artist.find(params[:id])
    @result = @discogs.search(@artist.name.to_s, per_page: 10, type: :artist)
    @artist_discogs = @discogs.get_artist(@result.results.first.id.to_s)
  end

  def test
    # #####Api ScrapScript#############
    artist_ids = []
    @find_category = Category.find_by(name: 'Thrash Metal')
    @category_id = @find_category.id

    @result = @discogs.search('Metallica', per_page: 10, type: :artist)
    @artist_discogs_name = @discogs.get_artist(@result.results.first.id.to_s)
    @artist_discogs_members = @discogs.get_artist(@result.results.first.id.to_s).members

    @saveband = Band.new(
      name: @artist_discogs_name.name,
      description: @artist_discogs_name.profile,
      category_id: @category_id
    )
    @saveband.save

    @artist_discogs_members.each do |artist|
      @save_artist = Artist.new(
        name: artist.name,
        category_id: @category_id
      )
      @save_artist.save
      artist_ids << @save_artist.id
    end

    artist_ids.each do |artist_id|
      @bandmembers = @saveband.bandmembers.build(artist_id: artist_id)
      @bandmembers.save
    end

    @artist = RSpotify::Artist.search('Metallica').first
    @band = Band.find_by(name: 'Metallica')
    uniq_album_names = @artist.albums.uniq!(&:release_date).uniq!(&:name)

    uniq_album_names.each do |album|
      @save_album = Album.new(
        name: album.name,
        release_date: album.release_date,
        category_id: @category_id,
        band_id: @band.id
      )
      @save_album.save
      @save_album.photos.create(image: URI.parse(album.images[0]['url']))

      songs_array = []
      album.tracks.each do |song|
        @song = Song.new(
          name: song.name,
          category_id: @category_id
        )
        @song.save
        songs_array << @song
      end

      songs_array.each do |_song|
        @tracks = @song.tracks.build(album_id: @save_album.id)
        @tracks.save
      end
    end
  end
end
