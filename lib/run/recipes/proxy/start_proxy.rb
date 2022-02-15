# frozen_string_literal: true

require "active_support"
require "interactor"
require "tty-command"
require "tty-file"

require_relative "../../recipe/step"
require_relative "../../base"

module Run
  module Recipes
    class Proxy < Recipe
      class StartProxy
        include Interactor
        include Run::Recipe::Step

        NGINX_IMAGE = "nginx:1.17.3-alpine"
        private_constant(:NGINX_IMAGE)

        def call
          check = cmd.run!("docker inspect -f '{{.State.Running}}' #{name}")
          # FIXME: Check for "false" output too!
          return if check.status.zero?

          result = cmd.run!(start_proxy_cmd)
          pp result
          context.fail!(error: "cannot start proxy") if result.failure?

          result = cmd.run!(
            File.join(
              __dir__,
              "wait-for-it.sh #{context.ip}:80 -t 7"
            )
          )

          context.fail!(error: "proxy startup timeout") if result.failure?
        rescue StandardError => e
          context.fail!(error: e.message)
        end

        private

        def name
          "#{context.name.parameterize}-proxy"
        end

        def start_proxy_cmd
          <<~CMD
            docker run \
            --name #{name} \
            -v #{File.join(Dir.pwd, Base::DIR)}/certs:/certs \
            -v #{File.join(Dir.pwd, Base::DIR)}/proxy/nginx.conf:/etc/nginx/sites-enabled/nginx.conf \
            --net=#{context.network.name} \
            -p 192.168.0.2:80:80 \
            -d \
            #{NGINX_IMAGE}
          CMD
        end

        def cmd
          @cmd ||= TTY::Command.new(printer: :null)
        end
      end
    end
  end
end
