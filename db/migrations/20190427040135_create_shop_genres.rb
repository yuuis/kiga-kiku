Hanami::Model.migration do
  change do
    create_table :shop_genres do
      column :code, String, null: false, primary_key: true
      column :name, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
