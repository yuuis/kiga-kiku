Hanami::Model.migration do
  change do
    create_table :user_went_shops do
      primary_key :id
      foreign_key :user_id, :users, on_delete: :cascade, null: false
      foreign_key :shop_id, :shops, on_delete: :cascade, null: false, type: String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
