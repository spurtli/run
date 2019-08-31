# frozen_string_literal: true

module Run
  class Base
    DIR = ".run"
    TMP_DIR = File.join(DIR, "tmp")

    class << self
      def create(basename:)
        FileUtils.mkdir_p(TMP_DIR)

        Tempfile.new(basename, TMP_DIR, encoding: "ascii-8bit")
      end
    end
  end
end
