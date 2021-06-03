class Transaction < ApplicationRecord
    has_paper_trail

    belongs_to :bank_account

    scope :active, -> { where(is_deleted: false) }

    validates :amount, presence: { message: "field_error_required"}
    validates :trans_type, presence: { message: "field_error_required"}

end
