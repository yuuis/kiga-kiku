Hanami::Model.migration do
  change do
    create_table :shop_genres do
      primary_key :code

      column :name, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
