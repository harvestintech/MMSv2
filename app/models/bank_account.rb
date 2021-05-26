class BankAccount < ApplicationRecord
    has_paper_trail

    has_many :transactions

    scope :active, -> { where(is_deleted: false) }
end
