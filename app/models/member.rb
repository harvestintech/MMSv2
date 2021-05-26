class Member < ApplicationRecord
    has_paper_trail

    scope :active, -> { where(is_deleted: false) }

    has_many :memberships
    has_many :member_histories
    has_many :membership_snapshots
    has_many :member_notifications
    has_many :member_cases

    # Personal information
    validates :email, presence:  { message: "field_error_required"}, format: { with: URI::MailTo::EMAIL_REGEXP } 
    validates :email, uniqueness:  { message: "field_error_unique"}
    validates :zh_first_name, presence: { message: "field_error_required"}
    validates :zh_last_name, presence: { message: "field_error_required"}
    validates :en_first_name, presence: { message: "field_error_required"}
    validates :en_last_name, presence: { message: "field_error_required"}
    validates :hkid, presence: { message: "field_error_required"}
    validates :birth_year, presence: { message: "field_error_required"}
    validates :birth_month, presence: { message: "field_error_required"}
    validates :address1, presence: { message: "field_error_required"}
    validates :phone, presence: { message: "field_error_required"}

    # Job information
    validates :company, presence: { message: "field_error_required"}
    validates :position, presence: { message: "field_error_required"}
    validates :company_address, presence: { message: "field_error_required"}
    validates :employment_type, presence: { message: "field_error_required"}

    # has_attached_file :employment_proof, 
    #         :path => ":rails_root/public/uploads/members/:id/:filename", 
    #         :url => ENV["BASE_URL"]+"/uploads/members/:id/:filename"

    # validates_attachment_content_type :employment_proof, content_type: ['image/jpeg', 'image/png', 'application/pdf'], size: { less_than: 5.megabytes }

end
