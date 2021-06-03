class AddIsActivedColToBankAccount < ActiveRecord::Migration[6.0]
  def up
    add_column :bank_accounts, :is_actived, :boolean, :default => true, :null => false
  end

  def down
    remove_column :bank_accounts, :is_actived
  end
end
