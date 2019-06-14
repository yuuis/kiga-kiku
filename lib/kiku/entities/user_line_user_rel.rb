class UserLineUserRel < Hanami::Entity
  attributes do
    attribute :user_id, Types::Int
    attribute :line_user_id, Types::String
  end
end

