class PreferenceGenreRanking < Hanami::Entity
  attributes do
    attribute :user_id, Types::Int
    attribute :order_index, Types::Int
    attribute :shop_genre_id, Types::String
    attribute :created_at, Types::Time
    attribute :updated_at, Types::Time
  end

  def name
    shop = ShopGenreRepository.new.find(shop_genre_id)
    shop.name unless shop.nil?
  end
end
