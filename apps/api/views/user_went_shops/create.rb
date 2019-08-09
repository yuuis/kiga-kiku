module Api::Views::UserWents
  class Create
    include Api::View
    layout false

    def render
      user_went.nil? ? '[]' : _raw(user_went.to_h.to_json)
    end
  end
end
