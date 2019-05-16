Hanami::Model.migration do
  change do
    create_table :shops do
      column :id, String, null: false, primary_key: true

      foreign_key :genre_code, :shop_genres, on_delete: :cascade, null: false, key: :code, type: String
      foreign_key :sub_genre_code, :shop_genres, on_delete: :cascade, null: false, key: :code, type: String
      foreign_key :large_area_code, :large_area, on_delete: :cascade, null: false, key: :code, type: String
      foreign_key :small_area_code, :small_area, on_delete: :cascade, null: false, key: :code, type: String
      foreign_key :budget_code, :budgets, ondelete: :cascade, null: false, key: :code, type: String
      foreign_key :service_area_code, :service_area, ondelete: :cascade, null: false, key: :code, type: String

      column :mobile_access, String, null: false
      column :address, String, null: false
      column :lng, String, null: false
      column :lat, String, null: false
      column :cource, String, null: false
      column :show, String, null: false
      column :non_smoking, String, null: false
      column :horigotatsu, String, null: false
      column :name, String, null: false
      column :open, String, null: false
      column :card, String, null: false
      column :tatami, String, null: false
      column :charter, String, null: false
      column :wifi, String, null: false
      column :shop_detail_memo, String, null: false
      column :band, String, null: false
      column :karaoke, String, null: false
      column :midnight, String, null: false
      column :urls, String, null: false
      column :english, String, null: false
      column :lunch, String, null: false
      column :close, String, null: false
      column :budget_memo, String, null: false
      column :tv, String, null: false
      column :private_room, String, null: false
      column :barrier_free, String, null: false
      column :child, String, null: false
      column :capacity, String, null: false
      column :pet, String, null: false
      column :free_food, String, null: false
      column :free_drink, String, null: false
      column :station_name, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
