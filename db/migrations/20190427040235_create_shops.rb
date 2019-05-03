Hanami::Model.migration do
  change do
    create_table :shops do
      primary_key :id
      foreign_key :genre_code, :shop_genres, on_delete: :cascade, null: false
      foreign_key :small_area_code, :small_areas, on_delete: :cascade, null: false

      column :code, String, null: false
      column :name, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
