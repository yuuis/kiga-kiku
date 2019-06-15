Hanami::Model.migration do
  change do
    create_table :locations do
      primary_key :id
      foreign_key :user_id, :users, on_delete: :cascade, null: false

      column :latitude, String, null: false
      column :longitude, String, null: false
      column :activity_type, String
      column :altitude, String
      column :uuid, String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
