class PaymentType < ApplicationRecord

    has_paper_trail

    has_many :payments
    has_many :claims

    scope :active, -> { where(is_deleted: false) }

    validates :name, uniqueness:  { message: "field_error_unique"}
    validates :name, presence: { message: "field_error_required"}

end
