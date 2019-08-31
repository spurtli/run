# frozen_string_literal: true

require "interactor"
require "tty-command"
require "tty-file"

require_relative "../../recipe/cache"
require_relative "../../recipe/step"

module Run
  module Recipes
    class Dns < Recipe
      class UpdateHostsFile < Step
        include Run::Recipe::Cache

        HOSTS_FILE = "/etc/hosts"
        private_constant(:HOSTS_FILE)

        CMD_ADD_HOST = "add_host.sh"
        private_constant(:CMD_ADD_HOST)

        cache(expires: 1.week)

        def call
          ip = context.ip
          host = context.host

          result = cmd.run(
            add_host(ip: ip, host: host)
          )
          context.fail!(error: "cannot add host") if result.failure?
        rescue StandardError => e
          context.fail!(error: e.message)
        end

        private

        def add_host(ip:, host:)
          @add_host ||= begin
            file = File.join(__dir__, CMD_ADD_HOST)
            File.read(file)
          end

          <<~BASH
            #{@add_host}

            add_host "#{ip}" "#{host}"
          BASH
        end

        def cmd
          @cmd ||= TTY::Command.new(printer: :null)
        end
      end
    end
  end
end
