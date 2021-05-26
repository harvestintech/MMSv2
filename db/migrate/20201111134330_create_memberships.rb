class CreateMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :memberships do |t|
      t.string :membership_ref, :null => false, :limit => 10, :index => true
      t.string :approved_by
      t.datetime :apprived_at
      t.string :year
      t.datetime :expired_at
      t.string :status, :default => "New"
      t.text :remark
      t.boolean :is_deleted, :default => false
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
