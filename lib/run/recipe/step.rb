# frozen_string_literal: true

require "interactor"

module Run
  class Recipe
    class Step
      include Interactor

      class << self
        def name
          full_name = super
          full_name.split("::").last
        end
      end
    end
  end
end
