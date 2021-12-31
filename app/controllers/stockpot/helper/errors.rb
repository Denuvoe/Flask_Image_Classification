
# frozen_string_literal: true

require "pg"
require "active_record"

module Stockpot
  module Helper
    module Errors
      def rescue_error(error)
        logger = Logger.new($stderr)
        logger.warn(error)

        case error
        when NameError
          return_error(error.message, :bad_request, error.backtrace.first(5))
        when PG::Error
          return_error("Postgres error: #{error.message}", :internal_server_error, error.backtrace.first(5))
        when ActiveRecord::RecordInvalid, ActiveRecord::Validations, ActiveRecord::RecordNotDestroyed
          return_error(%q(In "#{error.record.class}" class: "#{error.message}"), :expectation_failed, error.backtrace.first(5))
        else
          return_error(error.message, :internal_server_error, error.backtrace.first(5))
        end
      end

      def return_error(message, status, backtrace = "No backtrace")
        render json: { error: { status: status, backtrace: backtrace, message: message }}, status: status
      end
    end
  end
end