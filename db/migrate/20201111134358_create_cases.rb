class CreateCases < ActiveRecord::Migration[6.0]
  def change
    create_table :cases do |t|
      t.references :case_categorie,null: false, foreign_key: true
      t.string :ref_no, null: false, unique: true, index: true
      t.datetime :request_at
      t.string :client_name
      t.string :client_phone
      t.string :client_email
      t.text :desc
      t.string :follow_by
      t.string :status, :default => "New"
      t.boolean :is_deleted, :default => false
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
