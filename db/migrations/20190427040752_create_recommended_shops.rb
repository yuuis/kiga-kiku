Hanami::Model.migration do
  change do
    create_table :recommended_shops do
      primary_key :id
      foreign_key :shop_id, :shops, on_delete: :cascade, null: false, type: String
      foreign_key :recommend_log_id, :recommend_logs, on_delete: :cascade, null: false

      column :feed_back, Integer

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
