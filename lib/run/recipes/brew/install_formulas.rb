# frozen_string_literal: true

require "interactor"
require "tty-command"

require_relative "../../recipe/cache"
require_relative "../../recipe/step"

module Run
  module Recipes
    class Brew < Recipe
      class InstallFormulas < Step
        include Run::Recipe::Cache

        cache(expires: 1.week, attrs: %i[formulas])

        def self.name
          "Install formulas"
        end

        def call
          formulas = context.formulas

          formulas.each do |formula|
            result = cmd.run(
              "brew list #{formula} &>/dev/null || brew install #{formula}"
            )

            if result.failure?
              context.fail!(error: "cannot install formula: #{formula}")
            end
          end
        rescue StandardError => e
          context.fail!(error: e.message)
        end

        private

        def cmd
          @cmd ||= TTY::Command.new(printer: :null)
        end
      end
    end
  end
end
