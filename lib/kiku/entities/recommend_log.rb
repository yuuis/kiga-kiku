class RecommendLog < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :user_id, Types::Int
    attribute :day_of_the_week, Types::String
  end
end

