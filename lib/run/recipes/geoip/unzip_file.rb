# frozen_string_literal: true

require "interactor"
require "tty-command"

require_relative "../../base"
require_relative "../../recipe/cache"
require_relative "../../recipe/step"

module Run
  module Recipes
    class Geoip < Recipe
      class UnzipFile
        include Interactor
        include Run::Recipe::Step
        include Run::Recipe::Cache

        GEOIP_DB_PATH = "*/GeoLite2-City.mmdb"
        private_constant(:GEOIP_DB_PATH)

        cache(expires: 1.month, attrs: %i[destination])

        def call
          # get destination or set default
          default_path = File.join(Run::Base::TMP_DIR, "geoip.db")
          destination = context.destination || default_path
          dirname = File.dirname(destination)

          zipped_filepath = File.join(dirname, GEOIP_DB_PATH[2..-1])

          # create dir if not exist
          FileUtils.mkdir_p(dirname)

          # remove temporary unzipped file if exists
          FileUtils.rm_f(zipped_filepath)

          # unzip file
          result = cmd.run(
            "tar xf #{context.file} "\
              "--strip-components=1 -C #{dirname} #{GEOIP_DB_PATH}",
            only_output_on_error: true
          )

          # remove destination file if exists
          FileUtils.rm_f(destination)

          # move unzipped file to final destination
          FileUtils.mv(zipped_filepath, destination)

          context.fail!(error: "cannot unzip geoip database") if result.failure?

          # cleanup file
          context.file = nil
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
