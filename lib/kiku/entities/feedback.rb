class Feedback < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :user_id, Types::Int
    attribute :shop_id, Types::String
    attribute :feel, Types::Bool # 0: bad 1: good
  end
end

