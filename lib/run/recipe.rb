# frozen_string_literal: true

require "interactor"
require "tty-logger"
require "tty-spinner"

require_relative "recipe/dependency"

module Run
  class Recipe
    include Interactor::Organizer
    include Run::Recipe::Dependency

    SPINNER_FORMAT = :dots_2
    private_constant(:SPINNER_FORMAT)

    DEBUG = true
    private_constant(:DEBUG)

    def call
      start_time = Time.now
      steps = []

      header

      unless DEBUG
        spinners = TTY::Spinner::Multi.new(
          "[:spinner] Status",
          format: SPINNER_FORMAT
        )

        self.class.organized.each do |interactor|
          spinner = spinners.register("[:spinner] #{interactor.name}")
          steps << spinner
        end
      end

      self.class.organized.each_with_index do |interactor, idx|
        steps[idx].auto_spin unless DEBUG

        interactor.call!(context)

        steps[idx].success unless DEBUG
      rescue StandardError
        break steps[idx].error unless DEBUG
      end

      spinners.success unless DEBUG

      duration = Time.now - start_time
      footer(duration: duration.to_i)
    end

    private

    def header
      puts TTY::Box.frame(
        width: 60,
        height: 1,
        title: {
          top_left: humanized_name
        },
        border: {
          bottom: false
        }
      )
    end

    def footer(duration:)
      puts TTY::Box.frame(
        width: 59, # compensate for two-byte string of clock emoji
        height: 1,
        title: {
          bottom_right: "🕑 #{duration}s"
        },
        border: {
          top: false
        }
      )
    end

    def canonical_name
      self.class.name.split("::").last
    end

    def humanized_name
      canonical_name.humanize
    end

    def logger
      @logger ||= TTY::Logger.new
    end
  end
end
