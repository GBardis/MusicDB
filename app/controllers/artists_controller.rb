class ArtistsController < ApplicationController
  before_action do
    @discogs = Discogs::Wrapper.new("Test OAuth", user_token: 'uUAcpNNqtCmvrLITnpzKeuxfUcxsQdeGRJRggXqq')
  end
  before_action do
    RSpotify.authenticate('11180b801be74a9a9181777e6f78d5d9', '0e4a3494142b4b24b01f487b3ae6631d')

  end

  def show
    @artist = Artist.find(params[:id])
    @result =  @discogs.search(@artist.name.to_s, :per_page => 10, :type => :artist)
    @artist_discogs = @discogs.get_artist(@result.results.first.id.to_s)

  end
  def test
    # @result =  @discogs.search("metallica", :per_page => 10, :type => :artist)
    # @artist_discogs = @discogs.get_artist(@result.results.first.id.to_s)
    #
    # @saveband = Band.new(
    #   name: @artist_discogs.name,
    #   description: @artist_discogs.profile
    # )
    # @saveband.save
    #
    # @artist_discogs.members.each do |member|
    #   @result =  @discogs.search(member.name.to_s, :per_page => 10, :type => :artist)
    #   @artist_discogs = @discogs.get_artist(@result.results.first.id.to_s)
    #   @saveart = Artist.new(
    #     name: member.name,
    #     description: @artist_discogs.profile
    #   )
    #   @saveart.save
    # end
    # byebug
    #  @genres = @arcticmonkeys.genres
    #@albums = @arcticmonkeys.albums
    #byebug

    #  @result =  @discogs.search("metallica",:per_page => 100, :type => :artist)
    #@artist_discogs_songs = @discogs.get_artist_releases(@result.results.first.id.to_s)
    # @artist = Band.find_by(name: "Metallica")
    # @artist_discogs_songs.releases.each do |release|
    #   @song = Song.new(
    #     artist_id: @artist.id,
    #   name: release.title)
    # end
    ######NEW SCRIPT#############
    # @result =  @discogs.search("Metallica", :per_page => 10, :type => :artist)
    # @artist_discogs = @discogs.get_artist(@result.results.first.id.to_s)
    #
    # @saveband = Band.new(
    #   name: @artist_discogs.name,
    #   description: @artist_discogs.profile
    # )
    #@saveband.save
    @artist = RSpotify::Artist.search('Metallica').first
    @band = Band.find_by(name: 'Metallica')
    @artist.albums.each do |album|
      @saveband = Band.new(
        name: album.name,
        release_date: album.release_date,
        band_id: @band.id
      )

    end
  end
end
