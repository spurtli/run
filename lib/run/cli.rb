# frozen_string_literal: true

require "thor"

module Run
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc "version", "run version"

    def version
      require_relative "version"
      puts "v#{Run::VERSION}"
    end

    map %w[--version -v] => :version

    desc "down", "Teardown your dev environment"

    def down(*args)
      require_relative "commands/down"
      Run::Commands::Down.new(default_options).call(*args)
    end

    desc("up", "Setup your dev environment")

    def up(*args)
      require_relative "commands/up"
      Run::Commands::Up.new(default_options).call(*args)
    end

    private

    def default_options
      {
        shell: shell
      }
    end
  end
end
