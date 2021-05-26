class MembershipTransaction < ApplicationRecord

    has_paper_trail


    belongs_to :membership
    belongs_to :transaction, optional: true

    scope :active, -> { where(is_deleted: false) }

    validates :payment_method, presence: { message: "field_error_required"}

    Paperclip.interpolates :membership_ref do |attachment, style|
        attachment.instance.membership.membership_ref
    end

    Paperclip.interpolates :receipt_ref do |attachment, style|
        attachment.instance.receipt_ref
    end

    has_attached_file :document, 
            :path => ":rails_root/public/uploads/memberships/:membership_ref/transactions/doc/:filename", 
            :url => ENV["BASE_URL"]+"/uploads/memberships/:membership_ref/transactions/doc/:filename"

    validates_attachment_content_type :document, content_type: ['image/jpeg', 'image/png', 'application/pdf'], size: { less_than: 5.megabytes }

    has_attached_file :receipt, 
            :path => ":rails_root/public/uploads/memberships/:membership_ref/transactions/:receipt_ref", 
            :url => ENV["BASE_URL"]+"/uploads/memberships/:membership_ref/transactions/:receipt_ref"

    validates_attachment_content_type :receipt, content_type: ['image/jpeg', 'image/png', 'application/pdf'], size: { less_than: 5.megabytes }

end
