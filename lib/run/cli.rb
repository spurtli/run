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
    method_option :help, aliases: "-h", type: :boolean,
                         desc: "Display usage information"
    def down(*)
      if options[:help]
        invoke :help, ["down"]
      else
        require_relative "commands/down"
        Run::Commands::Down.new(options).execute
      end
    end

    desc("up", "Setup your dev environment")
    def up(*)
      if options[:help]
        invoke :help, ["up"]
      else
        require_relative "commands/up"
        Run::Commands::Up.new(options).execute
      end
    end
  end
end
