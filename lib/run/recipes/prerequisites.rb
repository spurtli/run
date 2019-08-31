# frozen_string_literal: true

require_relative "../recipe"

require_relative "prerequisites/check_os"
require_relative "prerequisites/check_prerequisites"

module Run
  module Recipes
    class Prerequisites < Recipe
      organize(Prerequisites::CheckOs, Prerequisites::CheckPrerequisites)
    end
  end
end
