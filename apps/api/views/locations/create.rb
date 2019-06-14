module Api::Views::Locations
  class Create
    include Api::View
    layout false

    def render
      location.nil? ? '[]' : _raw(location.to_h.to_json)
    end
  end
end

