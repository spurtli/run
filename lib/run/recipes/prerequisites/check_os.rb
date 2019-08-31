# frozen_string_literal: true

require "interactor"
require "tty-command"
require "tty-platform"
require "tty-which"

require_relative "../../recipe/step"

module Run
  module Recipes
    class Prerequisites < Recipe
      class CheckOs < Step
        SUPPORTED_OS = ["mac"].freeze
        private_constant(:SUPPORTED_OS)

        def self.name
          "Operating System (#{SUPPORTED_OS.join(', ')})"
        end

        def call
          result = SUPPORTED_OS.find do |name|
            platform.send("#{name}?")
          end

          if result.nil?
            context.fail!(
              error: "OS is not supported. `run` only supports "\
                      "\"#{SUPPORTED_OS.join(', ')}\""
            )
          end
        rescue StandardError => e
          context.fail!(error: e.message)
        end

        private

        def platform
          @platform ||= TTY::Platform.new
        end
      end
    end
  end
end
