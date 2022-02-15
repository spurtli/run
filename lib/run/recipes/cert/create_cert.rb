# frozen_string_literal: true

require "interactor"
require "tty-command"

require_relative "../../recipe/cache"
require_relative "../../recipe/step"
require_relative "../../base"

module Run
  module Recipes
    class Cert < Recipe
      class CreateCert
        include Interactor
        include Run::Recipe::Cache
        include Run::Recipe::Step

        cache(expires: 2.weeks)

        def call
          host = context.config["host"]
          output_path = File.join(Run::Base::DIR, "certs")

          FileUtils.mkdir_p(output_path)

          context.crt_file = File.join(output_path, "#{host}.pem")
          context.key_file = File.join(output_path, "#{host}.key.pem")

          result = cmd.run("mkcert -cert-file #{context.crt_file} "\
                            "-key-file #{context.key_file} #{host} *.#{host} "\
                            "localhost 127.0.0.1 ::1")

          context.fail!(error: "cannot create certificate") if result.failure?
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
