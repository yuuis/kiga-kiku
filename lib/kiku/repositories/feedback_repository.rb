# frozen_string_literal: true

class FeedbackRepository < Hanami::Repository
  associations do
    belongs_to :users
    belongs_to :shops
    has_many :conditions
  end
end
