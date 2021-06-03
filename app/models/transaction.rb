class Transaction < ApplicationRecord
    has_paper_trail

    belongs_to :bank_account

    scope :active, -> { where(is_deleted: false) }

    validates :amount, presence: { message: "field_error_required"}
    validates :trans_type, presence: { message: "field_error_required"}

    # def self.date_range_filter(column = "", fromStr = "",toStr = "")
    #     result = self

    #     if fromStr.present? || toStr.present?
    #         from = fromStr.present? ? fromStr.to_time.beginning_of_day : "1900-01-01".to_time.beginning_of_day
    #         to = toStr.present? ? toStr.to_time.end_of_day : DateTime.now.end_of_day

    #         case column
    #         when "trans_at"
    #             result = self.where(trans_at: from..to)
    #         when "confirm_at"
    #             result = self.where(confirm_at: from..to)
    #         when "handled_at"
    #             result = self.where(handled_at: from..to)
    #         when "bank_received"
    #             result = self.where(bank_received: from..to)
    #         end
    #     end
    #     result
    # end
end
