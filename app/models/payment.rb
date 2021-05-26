class Payment < ApplicationRecord
    has_paper_trail

    has_many :claim_payments

    belongs_to :payment_type

    validates :receipt_ref, presence: { message: "field_error_required"}
    validates :receipt_date, presence: { message: "field_error_required"}
    validates :receipt, presence: { message: "field_error_required"}
    validates :amount, presence: { message: "field_error_required"}
    validates :paid_to, presence: { message: "field_error_required"}
    validates :paid_at, presence: { message: "field_error_required"}

    has_attached_file :employment_proof, 
            :path => ":rails_root/public/uploads/payments/:id/:filename", 
            :url => ENV["BASE_URL"]+"/uploads/payments/:id/:filename"

    validates_attachment_content_type :employment_proof, content_type: ['image/jpeg', 'image/png', 'application/pdf'], size: { less_than: 5.megabytes }

end
