class CreateCaseMeetings < ActiveRecord::Migration[6.0]
  def change
    create_table :case_meetings do |t|
      t.references :case, null: false, foreign_key: true
      t.datetime :meet_at
      t.string :location
      t.text :desc
      t.string :status, :default => "New"
      t.boolean :is_deleted, :default => false
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
