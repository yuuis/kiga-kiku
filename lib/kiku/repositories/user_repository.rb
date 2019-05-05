# frozen_string_literal: true

class UserRepository < Hanami::Repository
  associations do
    has_many :recommend_logs
    has_many :feedbacks
  end
end
