# frozen_string_literal: true

require "interactor"
require "tty-command"
require "tty-which"

require_relative "../../recipe/step"

module Run
  module Recipes
    class Prerequisites < Recipe
      class CheckPrerequisites < Step
        PREREQUISITES = {
          brew: false,
          docker: false,
          git: true
        }.freeze
        private_constant(:PREREQUISITES)

        def self.name
          "Tools (#{PREREQUISITES.keys.join(', ')})"
        end

        def call
          PREREQUISITES.each(&method(:ensure_prerequisite_or_fail))
        rescue StandardError => e
          context.fail!(error: e.message)
        end

        private

        def ensure_prerequisite_or_fail(prerequisite, autoinstall)
          name = prerequisite.to_s

          result = TTY::Which.which(name)
          context.formulas.prepend(name) if result.nil? && autoinstall

          return unless result.nil?

          context.fail!(error: "cannot find \"#{name}\" and cannot install")
        end
      end
    end
  end
end
