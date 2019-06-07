Hanami::Model.migration do
  change do
    create_table :users do
      primary_key :id

      column :name, String, null: false
      column :birthday, Date
      column :gender, Integer
      column :married, TrueClass
      column :have_children, TrueClass
      column :smoker, TrueClass
      column :job, String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
