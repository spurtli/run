# frozen_string_literal: true

require "active_support/all"
require "digest"

require_relative "../base"

module Run
  class Recipe
    module Cache
      extend ActiveSupport::Concern

      included do
        class_attribute(:cache_enabled, default: false)
        class_attribute(:cache_expires)
        class_attribute(:cache_attrs)

        after(:cache_step)
      end

      class_methods do
        def cache(expires: 1.day, attrs: nil)
          self.cache_enabled = true
          self.cache_expires = expires
          self.cache_attrs = attrs
        end

        def cached?(context)
          return unless cache_enabled

          last_modified = if File.exist?(cache_file)
                            File.mtime(cache_file)
                          else
                            Time.at(0)
          end
          expired = (Time.now - last_modified) > cache_expires

          return false if expired

          content = cache_attrs.nil? ? context : context.to_h.slice(cache_attrs)

          old_checksum = File.read(cache_file)
          new_checksum = Digest::MD5.hexdigest(
            Marshal.dump(content)
          )

          old_checksum == new_checksum
        end

        def cache_file
          parts = to_s.split("::").pop(2)
          recipe = parts.first.underscore
          step = parts.last.underscore

          File.join(Run::Base::DIR, recipe, "#{step}.cache")
        end
      end

      def run!
        super unless self.class.cached?(context)
      end

      private

      def cache_step
        return unless self.class.cache_enabled?
        return if self.class.cached?(context)

        content = cache_attrs.nil? ? context : context.to_h.slice(cache_attrs)

        checksum = Digest::MD5.hexdigest(
          Marshal.dump(content)
        )

        dirname = File.dirname(self.class.cache_file)
        FileUtils.mkdir_p(dirname)

        File.write(self.class.cache_file, checksum)
      end
    end
  end
end
