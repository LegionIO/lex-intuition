# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.1] - 2026-03-17

### Added
- Add `lib/legion/extensions/intuition.rb` main entry point that was missing, causing a LoadError on load
- Disable `Gemspec/DevelopmentDependencies` rubocop cop and add `SuggestExtensions: false` to align with Legion extension conventions

## [0.1.0] - 2026-03-17

### Added
- Initial release of lex-intuition
- Recognition-primed decision making engine (`IntuitionEngine`)
- Fast-and-frugal heuristics (`Heuristic` helper)
- Pattern recognition with strength, reinforcement, and decay (`Pattern` helper)
- Constants for tuning thresholds and limits
- `Intuition` runner with learn, recognize, intuit, reinforce, heuristic, and stats functions
- `Client` wrapper for full learn-recognize-reinforce lifecycle
