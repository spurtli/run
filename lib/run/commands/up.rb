# frozen_string_literal: true

require "interactor"
require "tty-box"
require "tty-file"
require "tty-font"
require "tty-logger"
require "tty-progressbar"
require "tty-spinner"

require_relative "../command"
require_relative "../version"
require_relative "../recipes/prerequisites"
require_relative "../recipes/brew"
require_relative "../recipes/cert"
require_relative "../recipes/dns"
require_relative "../recipes/geoip"
require_relative "../recipes/proxy"

module Run
  module Commands
    class Up < Run::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        pipeline = Class.new do
          include Interactor::Organizer

          organize(
            Run::Recipes::Prerequisites,
            Run::Recipes::Brew,
            Run::Recipes::Cert,
            Run::Recipes::Dns,
            Run::Recipes::Geoip,
            Run::Recipes::Proxy
          )
        end

        result = pipeline.call(
          formulas: %w[mkcert nss postgres],
          ip: "192.168.4.2",
          name: "api.spurtli.io",
          host: "api.spurtli.io",
          port: "3000"
        )

        logger.error("run up failed: #{result}") if result.failure?
      end

      private

      def logger
        @logger ||= TTY::Logger.new
      end
    end
  end
end
