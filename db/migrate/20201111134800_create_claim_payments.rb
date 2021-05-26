class CreateClaimPayments < ActiveRecord::Migration[6.0]
  def change
    create_table :claim_payments do |t|
      t.references :payment, null: false, foreign_key: true
      t.references :claim, null: false, foreign_key: true
      t.timestamps
    end
  end
end
