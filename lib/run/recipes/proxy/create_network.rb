# frozen_string_literal: true

require "active_support"
require "erb"
require "tty-command"
require "tty-file"

require_relative "../../recipe/step"
require_relative "../../base"

module Run
  module Recipes
    class Proxy < Recipe
      class CreateNetwork < Step
        Network = Struct.new(:type, :subnet, :gateway, :name, keyword_init: true)
        private_constant(:Network)

        def call
          context.network = network

          check = cmd.run!("docker network ls | grep #{network.name}")
          return if check.status.zero?

          result = cmd.run(create_network_cmd)

          context.fail!(error: "cannot create network") if result.failure?
        rescue StandardError => e
          context.fail!(error: e.message)
        end

        private

        def name
          "#{context.name.parameterize}-net"
        end

        def network
          @network ||= Network.new(
            type: "bridge",
            subnet: "192.168.0.0/16",
            gateway: "192.168.0.1",
            name: name
          )
        end

        def create_network_cmd
          <<~CMD
            docker network create \
            -d #{network.type} \
            --subnet #{network.subnet} \
            --gateway #{network.gateway} \
            #{name}
          CMD
        end

        def cmd
          @cmd ||= TTY::Command.new(printer: :null)
        end
      end
    end
  end
end
