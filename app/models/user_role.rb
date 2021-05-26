class UserRole < ApplicationRecord
    has_paper_trail

    has_many :users

    scope :active, -> { where(is_deleted: false) }
    validates :name, presence:  { message: "field_error_required"}
    validates :name, uniqueness:  { scope: :is_deleted, message: "field_error_unique"}, :if =>  Proc.new { |a| !a.is_deleted }
    
end
