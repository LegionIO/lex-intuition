# frozen_string_literal: true

require_relative 'lib/legion/extensions/intuition/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-intuition'
  spec.version       = Legion::Extensions::Intuition::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'Intuition and pattern recognition for LegionIO'
  spec.description   = 'Recognition-primed decision making for LegionIO — ' \
                       'fast-and-frugal heuristics, pattern recognition, and compiled expertise'
  spec.homepage      = 'https://github.com/LegionIO/lex-intuition'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri']      = spec.homepage
  spec.metadata['source_code_uri']   = spec.homepage
  spec.metadata['documentation_uri'] = "#{spec.homepage}/blob/master/README.md"
  spec.metadata['changelog_uri']     = "#{spec.homepage}/blob/master/CHANGELOG.md"
  spec.metadata['bug_tracker_uri']   = "#{spec.homepage}/issues"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files         = Dir['lib/**/*']
  spec.require_paths = ['lib']
end
