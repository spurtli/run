# frozen_string_literal: true

require_relative "../recipe"

require_relative "proxy/create_config"
require_relative "proxy/create_network"
require_relative "proxy/fetch_image"
require_relative "proxy/start_proxy"

module Run
  module Recipes
    class Proxy < Recipe
      organize(
        Proxy::FetchImage,
        Proxy::CreateNetwork,
        Proxy::CreateConfig,
        Proxy::StartProxy
      )
    end
  end
end
