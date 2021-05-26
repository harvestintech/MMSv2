class Case < ApplicationRecord
    has_paper_trail

    has_many :case_meetings
    has_many :case_files
    has_many :member_cases

    belongs_to :case_categories

    scope :active, -> { where(is_deleted: false) }


    validates :ref_no, uniqueness:  { message: "field_error_unique"}
    validates :ref_no, presence: { message: "field_error_required"}
    validates :client_name, presence: { message: "field_error_required"}
end
