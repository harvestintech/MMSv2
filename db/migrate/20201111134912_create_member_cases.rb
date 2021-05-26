class CreateMemberCases < ActiveRecord::Migration[6.0]
  def change
    create_table :member_cases do |t|
      t.references :member, null: false, foreign_key: true
      t.references :case, null: false, foreign_key: true
      t.timestamps
    end
  end
end
