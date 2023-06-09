# frozen_string_literal: true

module Users
  class Admin < ApplicationRecord
    before_destroy :stop_destroy
    self.table_name = "users_admins"

    belongs_to :user

    def stop_destroy
      errors.add(:base, :undestroyable) if is_admin?
      throw error if is_admin?
    end
  end
end
