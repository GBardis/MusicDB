class AlbumsController < ApplicationController
  def index
    @album = AlbumsWithPopularityQuery.call
  end

end
