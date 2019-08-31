# frozen_string_literal: true

require_relative "../recipe"

require_relative "cert/install_ca"
require_relative "cert/create_cert"

module Run
  module Recipes
    class Cert < Recipe
      organize(Cert::InstallCA, Cert::CreateCert)
    end
  end
end
