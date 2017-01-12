module MtaIdentifiable
  extend ActiveSupport::Concern

  included do
    validates :mta_id, presence: true, uniqueness: true
  end

  class_methods do
    def find_by_mta_id(mta_id)
      find_by mta_id: mta_id
    end

    def find_or_initialize_by_mta_id(mta_id)
      find_or_initialize_by mta_id: mta_id
    end
  end
end
