Hanami::Model.migration do
  change do
    create_table :shops do
      primary_key :id

      foreign_key :genre_code, :shop_genres, on_delete: :cascade, null: false, key: :code, type: String
      foreign_key :small_area_code, :small_area, on_delete: :cascade, null: false, key: :code, type: String

      column :code, String, null: false
      column :name, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
