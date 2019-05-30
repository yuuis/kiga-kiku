Hanami::Model.migration do
  change do
    create_table :conditions do
      primary_key :id
      foreign_key :feedback_id, :feedbacks, on_delete: :cascade, null: false

      column :conditions, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
