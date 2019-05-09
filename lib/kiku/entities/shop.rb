class Shop < Hanami::Entity
  attributes do
    attribute :id, Types::String

    attribute :genre_code, Types::String
    attribute :sub_genre_code, Types::String
    attribute :small_area_code, Types::String
    attribute :large_area_code, Types::String
    attribute :budget_code, Types::String

    attribute :name, Types::String
    attribute :mobile_access, Types::String
    attribute :address, Types::String
    attribute :lng, Types::String
    attribute :lat, Types::String
    attribute :cource, Types::String
    attribute :show, Types::String
    attribute :non_smoking, Types::String
    attribute :horigotatsu, Types::String
    attribute :name, Types::String
    attribute :open, Types::String
    attribute :card, Types::String
    attribute :tatami, Types::String
    attribute :charter, Types::String
    attribute :wifi, Types::String
    attribute :shop_detail_memo, Types::String
    attribute :band, Types::String
    attribute :karaoke, Types::String
    attribute :midnight, Types::String
    attribute :urls, Types::String
    attribute :english, Types::String
    attribute :lunch, Types::String
    attribute :close, Types::String
    attribute :budget_memo, Types::String
    attribute :tv, Types::String
    attribute :private_room, Types::String
    attribute :barrier_free, Types::String
    attribute :child, Types::String
    attribute :capacity, Types::String
    attribute :pet, Types::String
    attribute :free_food, Types::String
    attribute :free_drink, Types::String
    attribute :station_name, Types::String
  end
end
