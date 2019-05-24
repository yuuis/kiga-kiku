module LineBot::Views::Callback
  class Root
    include LineBot::View
    layout false

    def render
      '[]'
    end
  end
end
