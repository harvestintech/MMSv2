class User < ApplicationRecord
    has_paper_trail

    has_many :user_tokens
    belongs_to :user_role
    
    has_secure_password
    serialize :mobile, EncryptedCoder.new

    scope :active, -> { where(is_deleted: false) }

    validates :email, presence:  { message: "field_error_required"}, format: { with: URI::MailTo::EMAIL_REGEXP } 
    validates :email, uniqueness:  { scope: :is_deleted, message: "field_error_unique"}, :if =>  Proc.new { |a| !a.is_deleted }
    validates :zh_name, presence: { message: "field_error_required"}
    validates :en_name, presence: { message: "field_error_required"}

    validates :password, confirmation: { message: "field_error_confirmation"}, unless: Proc.new { |a| a.password.blank? }
    validates :password_confirmation, presence: { message: "field_error_required"}, unless: Proc.new { |a| a.password.blank? }
    validates :password, presence: { message: "field_error_required"}, on: :create
    validates :password, length: { minimum: 8, message: "field_error_password_length" }, unless: Proc.new { |a| a.password.blank? }
    
end
