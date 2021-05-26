class CaseCategory < ApplicationRecord
    has_paper_trail

    has_many :cases

    scope :active, -> { where(is_deleted: false) }
    
    validates :name, presence: { message: "field_error_required"}

end
