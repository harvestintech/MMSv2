class Membership < ApplicationRecord
    has_paper_trail

    has_many :membership_transactions
    has_many :membership_snapshots

    belongs_to :member
    
    scope :active, -> { where(is_deleted: false) }

    # Add validation for uniqueness per member
    # validates :membership_ref, uniqueness:  { message: "field_error_unique"}
    
    validates :membership_ref, presence: { message: "field_error_required"}

end
