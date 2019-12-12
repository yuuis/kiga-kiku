# frozen_string_literal: true

class PreferenceGenreRankingRepository < Hanami::Repository
  associations do
    belongs_to :user
    belongs_to :shop_genre
  end

  def find_by_user_id(user_id)
    preference_genre_rankings.where(user_id: user_id).to_a
  end

  def reset_ranking_by_user_id(user_id)
    prev = preference_genre_rankings.where(user_id: user_id)
    prev.delete unless prev.to_a.empty?
  end
end
