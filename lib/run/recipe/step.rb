# frozen_string_literal: true

require "active_support/concern"
require "interactor"

require_relative "dependency"

module Run
  class Recipe
    module Step
      extend ActiveSupport::Concern

      included do
        around(:send_status)
      end

      class_methods do
        def canonical_name
          full_name = name
          full_name.split("::").last.underscore
        end

        def humanized_name
          canonical_name.humanize
        end
      end

      private

      def send_status(interactor)
        interactor.call
        logger.success(self.class.humanized_name) if context.success?
      rescue StandardError
        logger.error(self.class.humanized_name) if context.failure?
        raise
      end

      def logger
        @logger ||= TTY::Logger.new
      end
    end
  end
end
