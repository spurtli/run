# frozen_string_literal: true

require "interactor"
require "tty-command"
require "tty-file"

require_relative "../../recipe/step"

module Run
  module Recipes
    class Proxy < Recipe
      class FetchImage < Step
        NGINX_IMAGE = "nginx:1.17.3-alpine"
        private_constant(:NGINX_IMAGE)

        def call
          check = cmd.run!("test $(docker images -q #{NGINX_IMAGE})")
          return if check.status.zero?

          result = cmd.run("docker pull #{NGINX_IMAGE}")

          context.fail!(error: "cannot fetch nginx image") if result.failure?
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
