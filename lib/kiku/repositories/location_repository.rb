# frozen_string_literal: true

class LocationRepository < Hanami::Repository
  associations do
    belongs_to :user
  end
end
