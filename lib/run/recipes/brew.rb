# frozen_string_literal: true

require_relative "../recipe"

require_relative "brew/update_homebrew"
require_relative "brew/install_formulas"

module Run
  module Recipes
    class Brew < Recipe
      organize(Brew::UpdateHomebrew, Brew::InstallFormulas)

      def self.merge(*args)
        args.flatten
      end

      private

      def humanized_name
        "Homebrew"
      end
    end
  end
end
