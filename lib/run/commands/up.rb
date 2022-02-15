# frozen_string_literal: true

require "interactor"
require "tty-box"
require "tty-file"
require "tty-font"
require "tty-logger"
# require "tty-progressbar"
require "tty-spinner"

require_relative "../command"
require_relative "../version"
require_relative "../recipes/brew"
require_relative "../recipes/cert"
require_relative "../recipes/dns"
require_relative "../recipes/geoip"
require_relative "../recipes/prerequisites"
require_relative "../recipes/proxy"

module Run
  module Commands
    class Up < Run::Command
      RUN_FILE = "run.yml"
      private_constant(:RUN_FILE)

      def initialize(options)
        @options = options
      end

      def call(*_args)
        # defaults
        recipes = [
          [Run::Recipes::Prerequisites, nil]
        ]

        # load recipes
        recipes += config["up"].map do |value|
          recipe_name, recipe_config = extract_recipe_arguments(value)
          ["Run::Recipes::#{recipe_name.camelize}".constantize, recipe_config]
        end

        # resolve dependency order
        resolved = {}
        seen = Set[]

        recipes.each do |recipe, recipe_args|
          recipe.resolve(resolved, seen, recipe_args)
        end

        # simplify call structure
        call_list = resolved.map do |recipe, args|
          if args.size > 1
            args = recipe.merge(*args)
          else
            args = args.first
          end

          [recipe, args]
        end

        call_list.each do |pair|
          recipe, recipe_config = pair
          result = recipe.call(config: recipe_config)

          if result.failure?
            logger.error("run up failed for task '#{recipe.name}': #{result.error}")
            return
          end
        end
      end

      private

      def extract_recipe_arguments(value)
        return value, {} if value.is_a?(String)
        return value.first if value.is_a?(Hash)
        return value.first if value.is_a?(Array)

        raise "Cannot parse task config. Please check your '#{RUN_FILE}'"
      end

      def config
        pwd = find_project_working_dir(Dir.pwd)
        config_path = File.expand_path(RUN_FILE, pwd)

        YAML.load_file(config_path)
      end

      def find_project_working_dir(path)
        file_path = File.expand_path(RUN_FILE, path)

        return path if File.exist?(file_path)

        parent_dir = File.expand_path("..", path)
        raise "No run config found. Create a '#{RUN_FILE} and try again.'" if parent_dir == user_dir

        find_project_working_dir(parent_dir)
      end

      def user_dir
        ENV["HOME"]
      end

      def logger
        @logger ||= TTY::Logger.new
      end
    end
  end
end
