class CreateCaseCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :case_categories do |t|
      t.string :name, null: false
      t.text :desc
      t.boolean :is_deleted, :default => false
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
