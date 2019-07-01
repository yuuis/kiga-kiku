# frozen_string_literal: true

class UserLineUserRelRepository < Hanami::Repository
  associations do
    belongs_to :user
  end

  def find_by_line_user_id(line_user_id)
    user_line_user_rels.where(line_user_id: line_user_id).map_to(UserLineUserRel).to_a.first
  end
end
