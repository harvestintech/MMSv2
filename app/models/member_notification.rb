class MemberNotification < ApplicationRecord
    has_paper_trail

    belongs_to :member
    
    validates :notify_type, presence: { message: "field_error_required"}
    validates :notify_at, presence: { message: "field_error_required"}

end
