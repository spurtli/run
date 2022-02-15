# frozen_string_literal: true

require "interactor"
require "tty-command"
require "tty-which"

require_relative "../../recipe/step"

module Run
  module Recipes
    class Prerequisites < Recipe
      class CheckPrerequisites
        include Interactor
        include Run::Recipe::Step

        PREREQUISITES = %w[brew docker].freeze
        private_constant(:PREREQUISITES)

        def self.humanized_name
          "Tools (#{PREREQUISITES.keys.join(', ')})"
        end

        def call
          PREREQUISITES.each(&method(:ensure_prerequisite_or_fail))
        rescue StandardError => e
          context.fail!(error: e.message)
        end

        private

        def ensure_prerequisite_or_fail(prerequisite)
          name = prerequisite.to_s

          result = TTY::Which.which(name)
          return unless result.nil?

          context.fail!(error: "cannot find \"#{name}\"")
        end
      end
    end
  end
end
