# frozen_string_literal: true

require "interactor"
require "tty-file"

require_relative "../../recipe/cache"
require_relative "../../recipe/step"

module Run
  module Recipes
    class Geoip < Recipe
      class DownloadFile
        include Interactor
        include Run::Recipe::Step
        include Run::Recipe::Cache

        cache(expires: 1.month, attrs: %i[])

        GEOIP_DB_URL = "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=fV2ookgGTeYmfGSj&suffix=tar.gz"
        private_constant(:GEOIP_DB_URL)

        def call
          context.file = File.join(Run::Base::TMP_DIR, "geoip.db.tar.gz")

          TTY::File.download_file(GEOIP_DB_URL, context.file)
        rescue StandardError => e
          context.fail!(error: e.message)
        end
      end
    end
  end
end
