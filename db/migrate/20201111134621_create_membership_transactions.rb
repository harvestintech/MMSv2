class CreateMembershipTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :membership_transactions do |t|
      t.references :membership, null: false, foreign_key: true
      t.references :transaction, foreign_key: true
      t.string :receipt_ref
      t.attachment :receipt
      t.attachment :document
      t.string :payment_method
      t.string :confirm_by
      t.datetime :confirm_at
      t.decimal :amount, precision: 18, scale: 2
      t.text :remark
      t.boolean :is_deleted, :default => false
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
