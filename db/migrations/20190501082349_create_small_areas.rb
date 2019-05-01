Hanami::Model.migration do
  change do
    create_table :small_areas do
      primary_key :code

      column :name, Integer, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
