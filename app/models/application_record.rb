class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  class << self
    def paginate(offset = 0, limit = 25)
      offset = offset.to_i
      limit = limit.to_i
      limit(limit).offset(offset)
    end
    def creation_range(fromStr = "",toStr = "")
      from = fromStr.present? ? fromStr.to_time.beginning_of_day : "1900-01-01".to_time.beginning_of_day
      to = toStr.present? ? toStr.to_time.end_of_day : DateTime.now.end_of_day
      where(created_at: from..to)
    end

    def updated_range(fromStr = "",toStr = "")
      from = fromStr.present? ? fromStr.to_time.beginning_of_day : "1900-01-01".to_time.beginning_of_day
      to = toStr.present? ? toStr.to_time.end_of_day : DateTime.now.end_of_day
      where(updated_at: from..to)
    end
  end
end
