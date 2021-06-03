class ApplicationRecord < ActiveRecord::Base

  self.abstract_class = true
  
  class << self
    def date_range_filter(attrStr, fromStr = "",toStr = "")
      from = fromStr.present? ? fromStr.to_time.beginning_of_day : "1900-01-01".to_time.beginning_of_day
      to = toStr.present? ? toStr.to_time.end_of_day : DateTime.now.end_of_day
      where("#{attrStr}": from..to)
    end

    def decimal_range_filter(attrStr, fromStr = "",toStr = "")
      from = fromStr.present? ? fromStr.to_f : -Float::INFINITY
      to = toStr.present? ? toStr.to_f : Float::INFINITY
      where("#{attrStr}": from..to)
    end
    
    def paginate(offset = 0, limit = 25)
      offset = offset.to_i
      limit = limit.to_i
      limit(limit).offset(offset)
    end
  end
end
