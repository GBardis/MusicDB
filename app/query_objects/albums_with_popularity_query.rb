class AlbumsWithPopularityQuery
  POPULARITY_RANGES = 5

  def self.call
    Album.find_by_sql ['SELECT id, name,release_date, positive, negative,
          ((positive + 1.9208) / (positive + negative) -
          1.96 * SQRT((positive * negative) / (positive + negative) + 0.9604) /
          (positive + negative)) / (1 + 3.8416 / (positive + negative))
          AS ci_lower_bound
        FROM albums
        WHERE positive + negative > 0
        ORDER BY ci_lower_bound DESC']
  end
end
