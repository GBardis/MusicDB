class AlbumsController < ApplicationController
  def index
    @album = AlbumsWithPopularityQueryJob.set(wait: 10.seconds).perform_now
  end
end
