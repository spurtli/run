# frozen_string_literal: true

require "active_support/time"
require "interactor"
require "tty-command"

require_relative "../../recipe/cache"
require_relative "../../recipe/step"
require_relative "../../base"

module Run
  module Recipes
    class Brew < Recipe
      class UpdateHomebrew
        include Interactor
        include Run::Recipe::Step
        include Run::Recipe::Cache

        cache(expires: 1.week)

        def call
          # update brew and formulas
          result = cmd.run("brew update")

          context.fail!(error: "cannot update homebrew") if result.failure?
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
