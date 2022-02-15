# frozen_string_literal: true

require "interactor"
require "tty-command"

require_relative "../../recipe/cache"
require_relative "../../recipe/step"
require_relative "../../base"

module Run
  module Recipes
    class Cert < Recipe
      class InstallCA
        include Interactor
        include Run::Recipe::Step
        include Run::Recipe::Cache

        cache(expires: 1.month)

        def self.humanized_name
          "Install local CA"
        end

        def call
          # install local CA
          result = cmd.run("mkcert -install")

          context.fail!(error: "cannot install CA") if result.failure?
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
