# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "run/version"

Gem::Specification.new do |spec|
  spec.name          = "run"
  spec.license       = "MIT"
  spec.version       = Run::VERSION
  spec.authors       = ["Hannes Moser"]
  spec.email         = ["box@hannesmoser.at"]

  spec.summary       = "Setup your dev environment with a single command."
  spec.description   = "Declaratie config of you development environment."
  spec.homepage      = "https://www.spurtli.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/spurtli/run"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "pastel", "~> 0.7.2"
  spec.add_dependency "thor", "~> 0.20.0"
  spec.add_dependency "tty-box", "~> 0.3.0"
  spec.add_dependency "tty-color", "~> 0.4"
  spec.add_dependency "tty-command", "~> 0.8.0"
  spec.add_dependency "tty-config", "~> 0.3.0"
  spec.add_dependency "tty-cursor", "~> 0.6"
  spec.add_dependency "tty-editor", "~> 0.5.0"
  spec.add_dependency "tty-file", ">= 0.7", "< 0.9"
  spec.add_dependency "tty-font", "~> 0.2.0"
  spec.add_dependency "tty-markdown", "~> 0.5.0"
  spec.add_dependency "tty-pager", "~> 0.12.0"
  spec.add_dependency "tty-pie", "~> 0.1.0"
  spec.add_dependency "tty-platform", "~> 0.2.0"
  spec.add_dependency "tty-progressbar", "~> 0.16.0"
  spec.add_dependency "tty-prompt", "~> 0.18.0"
  spec.add_dependency "tty-screen", "~> 0.6"
  spec.add_dependency "tty-spinner", "~> 0.9.0"
  spec.add_dependency "tty-table", "~> 0.10.0"
  spec.add_dependency "tty-tree", "~> 0.2.0"
  spec.add_dependency "tty-which", "~> 0.4"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rspec"
end
