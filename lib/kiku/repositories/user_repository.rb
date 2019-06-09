# frozen_string_literal: true

class UserRepository < Hanami::Repository
  associations do
    has_many :recommend_transactions
    has_many :feedbacks
  end
end
