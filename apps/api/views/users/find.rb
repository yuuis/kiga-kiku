module Api::Views::Users
  class Find
    include Api::View
    layout false

    def render
      binding.pry
      user_id.nil? ? '[]' : _raw({ user_id: user_id }.to_json)
    end
  end
end
