# frozen_string_literal: true

module Users
  class Admin < ApplicationRecord
    before_destroy :stop_destroy
    self.table_name = "users_admins"