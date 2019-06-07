class RecommendConversation < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :conditions, Types::String
    attribute :user_word, Types::String
    attribute :bot_word, Types::String
  end
end
