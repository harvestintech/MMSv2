class CreateCaseFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :case_files do |t|
      t.references :case, null: false, foreign_key: true
      t.attachment :file
      t.boolean :is_deleted, :default => false
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
