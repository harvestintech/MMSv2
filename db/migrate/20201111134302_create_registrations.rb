class CreateRegistrations < ActiveRecord::Migration[6.0]
  def change
    create_table :registrations do |t|
      t.references :member, foreign_key: true
      t.string :zh_first_name
      t.string :zh_last_name
      t.string :en_first_name
      t.string :en_last_name
      t.string :phone
      t.string :email
      t.string :work_phone
      t.string :hkid
      t.string :gender
      t.string :birth_year
      t.string :birth_month
      t.string :birth_date
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :country
      t.string :zip_code
      t.string :post_address1
      t.string :post_address2
      t.string :post_city
      t.string :post_state
      t.string :post_country
      t.string :post_zip_code
      t.string :company
      t.string :company_address
      t.string :department
      t.string :position
      t.string :employment_type
      t.attachment :employment_proof
      t.boolean :declare, :default => false
      t.boolean :agreement, :default => false
      t.string :status, :default => "New"
      t.string :handled_by, null: true, :default => nil
      t.datetime :handled_at, null: true, :default => nil
      t.text :remark
      t.boolean :is_deleted, :default => false
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
