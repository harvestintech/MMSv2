class CaseMeeting < ApplicationRecord
    has_paper_trail
    
    belongs_to :case

    scope :active, -> { where(is_deleted: false) }

end
