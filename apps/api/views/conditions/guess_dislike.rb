module Api::Views::Conditions
  class GuessDislike
    include Api::View
    layout false

    def render
      conditions.nil? ? '[]' : _raw(conditions.to_json)
    end
  end
end
