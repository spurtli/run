# frozen_string_literal: true

require "active_support/concern"
require "interactor"

module Run
  class Recipe
    module Dependency
      extend ActiveSupport::Concern

      included do
        around(:send_status)
      end

      class_methods do
        def dependency(recipe, *args)
          dependencies << [recipe, *args]
        end

        def merge(*_args)
          raise "Implement merge in #{name}"
        end

        def resolve(resolved, unresolved, args)
          unresolved.add(self.name)

          dependencies.each do |dependency, dependency_args|
            unless resolved.key?(dependency)
              if unresolved.include?(dependency)
                raise "Circular reference detected: #{self.name} -> #{dependency}"
              end

              dependency.constantize.resolve(resolved, unresolved, dependency_args)
            end
          end

          resolved[self.name.constantize] = [] unless resolved.key?(self.name.constantize)
          resolved[self.name.constantize] << args

          unresolved.delete(self.name)
        end

        def dependencies
          @dependencies ||= []
        end
      end
    end
  end
end
