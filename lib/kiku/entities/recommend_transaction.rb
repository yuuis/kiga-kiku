class RecommendTransaction < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :user_id, Types::Int
  end
end
