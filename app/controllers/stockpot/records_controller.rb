
# frozen_string_literal: true

require "factory_bot_rails"
require "active_record/transactions"

module Stockpot
  class RecordsController < MainController
    include ActiveSupport::Inflector
    include ActiveRecord::Transactions
    include Helper::Errors

    before_action only: %i[index destroy update] do
      return_error("You need to provide at least one model name as an argument", 400) if params[:models].blank?
    end
    before_action only: %i[create] do
      return_error("You need to provide at least one factory name as an argument", 400) if params[:factories].blank?
    end
    before_action do
      @response_data = {}
    end

    def index
      models.each_with_index do |element, i|
        model = element[:model]
        class_name = find_correct_class_name(model)
        formatted_model = pluralize(model).camelize(:lower).gsub("::", "")

        @response_data[formatted_model] = [] unless @response_data.key?(formatted_model)
        @response_data[formatted_model].concat(class_name.constantize.where(models[i].except(:model)))
        @response_data[formatted_model].reverse!.uniq!
      end
      render json: @response_data, status: :ok
    end

    def create
      ActiveRecord::Base.transaction do
        factories.each do |element|
          ids = []
          list = element[:list] || 1
          factory = element[:factory]
          traits = element[:traits].map(&:to_sym) if element[:traits].present?

          list.times do |n|
            attributes = element[:attributes][n].to_h if element[:attributes].present?
            factory_arguments = [ factory, *traits, attributes ].compact
            @factory_instance = FactoryBot.create(*factory_arguments)
            ids << @factory_instance.id