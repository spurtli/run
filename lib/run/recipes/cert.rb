# frozen_string_literal: true

require_relative "../recipe"

require_relative "cert/install_ca"
require_relative "cert/create_cert"

module Run
  module Recipes
    class Cert < Recipe
      dependency("Run::Recipes::Brew", %w[mkcert])

      organize(Cert::InstallCA, Cert::CreateCert)

      private

      def humanized_name
        "Certificate"
      end
    end
  end
end
