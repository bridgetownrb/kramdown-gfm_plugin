# frozen_string_literal: true

require_relative "lib/kramdown/gfm_plugin/version"

Gem::Specification.new do |spec|
  spec.name = "kramdown-gfm_plugin"
  spec.version = Kramdown::GfmPlugin::VERSION
  spec.author = "Bridgetown Team"
  spec.email = "maintainers@bridgetownrb.com"

  spec.summary = "Provides GitHub-flavored Markdown parsing via the Kramdown Plugins system"
  spec.homepage = "https://github.com/bridgetownrb/kramdown-gfm_plugin"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "kramdown-plugins", "~> 0.1"
end
