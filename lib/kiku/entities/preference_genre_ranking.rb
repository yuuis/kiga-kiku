class PreferenceGenreRanking < Hanami::Entity
  attributes do
    attribute :user_id, Types::Int
    attribute :order_index, Types::Int
    attribute :shop_genre_id, Types::String
    attribute :created_at, Types::Time
    attribute :updated_at, Types::Time
  end
end
