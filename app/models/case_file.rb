class CaseFile < ApplicationRecord
    has_paper_trail
    
    belongs_to :case

    scope :active, -> { where(is_deleted: false) }

    Paperclip.interpolates :case_ref do |attachment, style|
        attachment.instance.case.ref_no
    end

    has_attached_file :employment_proof, 
            :path => ":rails_root/public/uploads/cases/:case_ref/:filename", 
            :url => ENV["BASE_URL"]+"/uploads/cases/:case_ref/:filename"

    validates_attachment_content_type :employment_proof, content_type: ['image/jpeg', 'image/png', 'application/pdf','application/msword'], size: { less_than: 10.megabytes }

end
