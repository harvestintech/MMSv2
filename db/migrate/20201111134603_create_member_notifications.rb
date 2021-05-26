class CreateMemberNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :member_notifications do |t|
      t.references :member,null: false, foreign_key: true
      t.string :notify_type
      t.text :notify_desc
      t.datetime :notify_at
      t.string :status, :default => "New"
      t.boolean :is_deleted, :default => false
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
