module UUID
  extend ActiveSupport::Concern

  included do
    validates :uuid, uniqueness: { message: 'has already been taken. Please refresh.' }

    after_initialize :set_uuid, unless: :uuid

    def set_uuid
      self.uuid = SecureRandom.uuid
    end
  end

end
