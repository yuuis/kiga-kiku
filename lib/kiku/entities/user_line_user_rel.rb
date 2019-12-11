class UserLineUserRel < Hanami::Entity
  attributes do
    attribute :user_id, Types::Int
    attribute :line_user_id, Types::String
    attribute :created_at, Types::Time
    attribute :updated_at, Types::Time
  end

  def to_user
    UserRepository.new.find(user_id)
  end
end
