class UserLineUserRel < Hanami::Entity
  attributes do
    attribute :user_id, Types::String
    attribute :created_at, Types::Time
    attribute :updated_at, Types::Time
  end
end
