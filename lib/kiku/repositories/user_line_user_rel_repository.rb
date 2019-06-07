# frozen_string_literal: true

class UserLineUserRelRepository < Hanami::Repository
  associations do
    belongs_to :user
  end
end
