# frozen_string_literal: true

class LocationRepository < Hanami::Repository
  associations do
    belongs_to :user
  end

  def latest(user_id)
    locations.where(user_id: user_id).map_to(Location).to_a.last
  end

  def find_all_by_user_id(user_id)
    locations.where(user_id: user_id).map_to(Location).to_a
  end
end
