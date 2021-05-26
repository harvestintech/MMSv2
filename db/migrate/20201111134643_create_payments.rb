class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.references :payment_type, null: false, foreign_key: true
      t.string :paid_to
      t.datetime :paid_at
      t.string :approved_by
      t.datetime :approved_at
      t.string :handled_by
      t.datetime :handled_at
      t.string :receipt_ref
      t.datetime :receipt_date
      t.attachment :receipt
      t.decimal :amount, precision: 18, scale: 2
      t.string :status, :default => "New"
      t.text :remark
      t.boolean :is_deleted, :default => false
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
