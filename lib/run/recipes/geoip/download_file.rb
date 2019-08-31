# frozen_string_literal: true

require "interactor"
require "tty-file"

require_relative "../../recipe/cache"
require_relative "../../recipe/step"

module Run
  module Recipes
    class Geoip < Recipe
      class DownloadFile < Step
        include Run::Recipe::Cache

        cache(expires: 1.month, attrs: %i[])

        GEOIP_DB_URL = "https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz"
        private_constant(:GEOIP_DB_URL)

        def call
          context.file = File.join(Run::Base::TMP_DIR, "geoip.db.tar.gz")

          TTY::File.download_file(
            GEOIP_DB_URL,
            context.file
          )
        rescue StandardError => e
          context.fail!(error: e.message)
        end
      end
    end
  end
end
