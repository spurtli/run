# frozen_string_literal: true

require_relative "../recipe"

require_relative "brew/update_homebrew"
require_relative "brew/install_formulas"

module Run
  module Recipes
    class Brew < Recipe
      organize(Brew::UpdateHomebrew, Brew::InstallFormulas)
    end
  end
end
