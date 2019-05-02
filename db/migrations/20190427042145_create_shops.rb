Hanami::Model.migration do
  change do
    create_table :shops do
      primary_key :id

      column :code, String, null: false
      column :name, String, null: false
      column :genre_code, String, null: false
      column :small_area_code, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
