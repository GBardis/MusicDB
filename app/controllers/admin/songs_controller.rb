class Admin::SongsController < AdminController
  before_action :require_admin
  before_action :set_songs, only: %i[update destroy]

  def index_song
    @songs = Song.includes(tracks: :album).all
  end

  def new_song
    @song = Song.new
    @albums = Album.all.map { |x| [x.name, x.id] }
    @artists = Artist.all.map { |x| [x.name.to_s, x.id.to_s] }
  end

  def create
    @song = Song.new(song_params)

    if @song.save!
      if params[:song][:albums]
        params[:song][:albums].each do |album|
          @tracks = @song.tracks.build(album_id: album)
          @tracks.save
        end
      end
      flash[:success] = "Song #{@song.name} saved!"
      redirect_to admin_songs_path
    else
      flash[:danger] = 'Please try again'
      redirect_to admin_songs_new_path
    end
  end

  def edit_song
    @song = Song.find(params[:id])
    @albums = Album.all.map { |x| [x.name.to_s, x.id.to_s] }
    @count = Track.where(song_id: @song.id)

    @array = []
    if @count.size > 1
      @count.each do |album|
        @album = Album.find(album.album_id).id
        @array << @album
      end
    elsif @count.size == 1
      @count = Track.find_by(song_id: @song.id)
      @album = Album.find(@count.album_id).id
      @array << @album
    else
      @array = ['']
    end
  end

  def update
    if @song.update_attributes(song_params)
      if params[:song][:albums]
        params[:song][:albums].each do |album|
          @tracks = @song.tracks.build(album_id: album) # unless album.empty?
          @tracks.save # unless album.empty?
          ## byebug
        end
      end
      flash[:success] = 'Song updated!'
      redirect_to admin_songs_path
    else
      flash[:warning] = 'Please try again'
      redirect_to admin_songs_edit_path(@song)
    end
  end

  def destroy
    @song.destroy
    flash[:success] = 'Song deleted!'
    redirect_to admin_songs_path
  end

  private

  def set_songs
    @song = Song.find(params[:id])
  end

  def song_params
    params.require(:song).permit(:name, :album_id, :artist_id, :band_id, albums: [:id])
  end
end
