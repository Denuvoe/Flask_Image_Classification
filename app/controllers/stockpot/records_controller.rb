
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
          end

          factory_name = pluralize(factory).camelize(:lower)

          @response_data[factory_name] = [] unless @response_data.key?(factory_name)
          @response_data[factory_name].concat(@factory_instance.class.name.constantize.where(id: ids))
        end
      end
      render json: @response_data, status: :accepted
    end

    def destroy
      ActiveRecord::Base.transaction do
        models.each_with_index do |element, i|
          model = element[:model]
          class_name = find_correct_class_name(model)
          formatted_model = pluralize(model).camelize(:lower).gsub("::", "")

          class_name.constantize.where(models[i].except(:model)).each do |record|
            record.destroy!
            @response_data[formatted_model] = [] unless @response_data.key?(formatted_model)
            @response_data[formatted_model] << record
          end
        end
      end
      render json: @response_data, status: :accepted
    end

    def update
      ActiveRecord::Base.transaction do
        models.each_with_index do |element, i|
          model = element[:model]
          class_name = find_correct_class_name(model)
          update_params = params.permit![:models][i][:update].to_h
          attributes_to_search = models[i].except(:model, :update)
          formatted_model = pluralize(model).camelize(:lower).gsub("::", "")

          class_name.constantize.where(attributes_to_search).each do |record|
            record.update!(update_params)
            @response_data[formatted_model] = [] unless @response_data.key?(formatted_model)
            @response_data[formatted_model] << class_name.constantize.find(record.id)
            @response_data[formatted_model].reverse!.uniq! { |obj| obj["id"] }
          end
        end
      end
      render json: @response_data, status: :accepted
    end

    private

    def find_correct_class_name(model)
      # We are getting the class name from the factory or we default to whatever we send in.
      # Something to keep in mind "module/class_name".camelize will translate into "Module::ClassName"
      # which is perfect for namespaces in case there is no factory associated with a specific model
      if FactoryBot.factories.registered?(model)
        FactoryBot.factories.find(model).build_class.to_s
      else
        model.camelize
      end
    end

    def models
      params.permit![:models].map(&:to_h)
    end

    def factories
      params.permit![:factories].map(&:to_h)
    end
  end
end