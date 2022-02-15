# frozen_string_literal: true

require "interactor"
require "tty-command"

require_relative "../../recipe/cache"
require_relative "../../recipe/step"

module Run
  module Recipes
    class Brew < Recipe
      class InstallFormulas
        include Interactor
        include Run::Recipe::Step
        include Run::Recipe::Cache

        cache(expires: 1.week, attrs: %i[formulas])

        def call
          formulas = context.config
          formulas.each do |formula|
            result = cmd.run(
              "brew list #{formula} &>/dev/null || brew install #{formula}"
            )

            context.fail!(error: "cannot install formula: #{formula}") if result.failure?
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
