require 'hanami/interactor'
require 'pry'

class GeneratePreferenceGenreRanking
  include Hanami::Interactor

  def call(user_id)
    @user = UserRepository.new.find(user_id)

    sorted_list = sort_and_group_by_genre(extract_went_genre_duplicate_list)
    return nil if sorted_list.empty?

    sorted_list.each_with_index do |_genre_id, index|
      p index
    end
  end

  private

  def extract_went_genre_duplicate_list
    return [] if @user.nil?

    user_went_shops = UserWentShopRepository.new.findby_user_id(@user.id)
    return [] if user_went_shops.empty?

    genre_duplicate_list = []
    user_went_shops.each do |shop|
      genre_duplicate_list << shop.shop_id
    end
    genre_duplicate_list
  end

  def sort_and_group_by_genre(genre_list)
    genre_list.group_by { |e| e }.sort_by { |_, v| -v.size }.map(&:first)
  end
end
