class Claim < ApplicationRecord
    has_paper_trail

    belongs_to :payment_type
    belongs_to :user

    has_one :claim_payment
    
    scope :active, -> { where(is_deleted: false) }

    validates :receipt_ref, presence: { message: "field_error_required"}
    validates :receipt, presence: { message: "field_error_required"}
    validates :receipt_date, presence: { message: "field_error_required"}
    validates :paid_to, presence: { message: "field_error_required"}
    validates :paid_by, presence: { message: "field_error_required"}
    validates :paid_at, presence: { message: "field_error_required"}
    validates :amount, presence: { message: "field_error_required"}

    has_attached_file :employment_proof, 
            :path => ":rails_root/public/uploads/claims/:id/:filename", 
            :url => ENV["BASE_URL"]+"/uploads/claims/:id/:filename"

    validates_attachment_content_type :employment_proof, content_type: ['image/jpeg', 'image/png', 'application/pdf'], size: { less_than: 5.megabytes }

end
