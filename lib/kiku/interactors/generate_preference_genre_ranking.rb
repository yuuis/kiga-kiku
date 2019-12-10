require 'hanami/interactor'

class GeneratePreferenceGenreRanking
  include Hanami::Interactor

  def call(user_id)
    sorted_list = sort_and_group_by_genre(extract_went_genre_duplicate_list(user_id))
    return nil if sorted_list.empty?

    PreferenceGenreRankingRepository.new.reset_ranking_by_user_id(user_id)

    sorted_list.each_with_index do |genre_id, index|
      PreferenceGenreRankingRepository.new.create(user_id: user_id, order_index: index, shop_genre_id: genre_id)
    end
  end

  private

  def extract_went_genre_duplicate_list(user_id)
    return [] if user_id.nil?

    user_went_shops = UserWentShopRepository.new.findby_user_id(user_id)
    return [] if user_went_shops.empty?

    genre_duplicate_list = []
    user_went_shops.each do |shop|
      genre_duplicate_list << ShopRepository.new.find(shop.shop_id).genre_code
    end
    genre_duplicate_list
  end

  def sort_and_group_by_genre(genre_list)
    genre_list.group_by { |e| e }.sort_by { |_, v| -v.size }.map(&:first)
  end
end
