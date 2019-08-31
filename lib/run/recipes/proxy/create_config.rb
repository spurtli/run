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
      class CreateConfig < Step
        ConfigValues = Struct.new(
          :name,
          :host,
          :ip,
          :port,
          :services,
          :crt_file,
          :key_file
        ) do
          def get_binding
            binding
          end
        end
        private_constant(:ConfigValues)

        def call
          template = ERB.new(template_string)
          config = template.result(values.get_binding)
          save_config(config)
        rescue StandardError => e
          context.fail!(error: e.message)
        end

        private

        def values
          ConfigValues.new(
            context.name,
            context.host,
            context.network.gateway,
            "3000",
            [],
            context.crt_file,
            context.key_file
          )
        end

        def save_config(str)
          filepath = File.join(Base::DIR, "proxy", "nginx.conf")
          directory = File.dirname(filepath)

          FileUtils.mkdir_p(directory)

          File.write(filepath, str)
        end

        def template_string
          File.read(
            File.join(__dir__, "config", "nginx.conf.erb")
          )
        end
      end
    end
  end
end
