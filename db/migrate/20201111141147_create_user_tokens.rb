class CreateUserTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :user_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token, :index => true, :null => false
      t.datetime :expired_at
      t.string :login_ip
      t.timestamps
    end
  end
end
