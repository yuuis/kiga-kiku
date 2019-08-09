Hanami::Model.migration do
  change do
    create_table :user_went_shops do
      primary_key :id
      foreign_key :user_id, :users, on_delete: :cascade, null: false

      column :shop_id, String, null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
