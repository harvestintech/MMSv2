class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  class << self
    def paginate(offset = 0, limit = 25)
      offset = offset.to_i
      limit = limit.to_i

      limit(limit).offset(offset)
    end
  end
end
