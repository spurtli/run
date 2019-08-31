# frozen_string_literal: true

require_relative "../recipe"

require_relative "dns/update_hosts_file"

module Run
  module Recipes
    class Dns < Recipe
      organize(Dns::UpdateHostsFile)
    end
  end
end
