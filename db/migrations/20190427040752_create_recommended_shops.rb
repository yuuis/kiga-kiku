Hanami::Model.migration do
  change do
    create_table :recommended_shops do
      primary_key :id

      column :shop_id, String, null: false
      column :feed_back, TrueClass

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
