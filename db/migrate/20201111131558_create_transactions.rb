class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.references :bank_account, null: false, foreign_key: true
      t.datetime :trans_at 
      t.string :trans_type
      t.text :trans_desc
      t.decimal :amount, precision: 18, scale: 2
      t.string :handled_by, null: true, :default => nil
      t.datetime :handled_at, null: true, :default => nil
      t.string :confirm_by, null: true, :default => nil
      t.datetime :confirm_at, null: true, :default => nil
      t.string :bank_ref, null: true, :default => nil
      t.datetime :bank_received, null: true, :default => nil
      t.text :remark
      t.boolean :is_deleted, :default => false
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
