# frozen_string_literal: true

require_relative "../recipe"

require_relative "geoip/download_file"
require_relative "geoip/unzip_file"

module Run
  module Recipes
    class Geoip < Recipe
      organize(Geoip::DownloadFile, Geoip::UnzipFile)
    end
  end
end
