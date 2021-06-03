class ChangeRegistrationMaptoMembership < ActiveRecord::Migration[6.0]
  def up
    add_reference :registrations, :membership, foreign_key: true
    remove_reference :registrations, :member, foreign_key: true
  end

  def down
    add_reference :registrations, :member, foreign_key: true
    remove_reference :registrations, :membership, foreign_key: true
  end
end
