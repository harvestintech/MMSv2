class UserToken < ApplicationRecord
    belongs_to :user

    scope :active, -> { where("expired_at > ?",DateTime.now) }

    before_create do
        self.expired_at = DateTime.now + 1.month
    end
end
