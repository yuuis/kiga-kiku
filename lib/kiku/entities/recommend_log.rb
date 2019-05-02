class RecommendLog < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :user_id, Types::Int
    attribute :search_words, Types::String
  end
end
