# lex-intuition

Pattern recognition and heuristic reasoning for LegionIO agents. Part of the LegionIO cognitive architecture extension ecosystem (LEX).

## What It Does

`lex-intuition` implements fast, pattern-based cognition. It learns context-outcome associations from repeated experience, matches new contexts against known patterns via overlap scoring, and applies registered heuristics as cognitive shortcuts. Patterns progress from forming to reliable to expert as they accumulate encounters and strength.

Key capabilities:

- **Pattern learning**: context-outcome pairs learned from experience
- **Recognition**: match new contexts against known patterns (Jaccard-style key overlap)
- **Heuristics**: fast cognitive shortcuts registered by domain and type
- **Pattern maturity**: forming -> reliable (strength>=0.65, encounters>=3) -> expert (strength>=0.85, encounters>=10)
- **Confidence labels**: very_low to very_high based on match strength

## Installation

Add to your Gemfile:

```ruby
gem 'lex-intuition'
```

Or install directly:

```
gem install lex-intuition
```

## Usage

```ruby
require 'legion/extensions/intuition'

client = Legion::Extensions::Intuition::Client.new

# Learn from experience
client.learn_intuitive_pattern(
  context: { domain: :deployment, risk: :high, time_pressure: true },
  outcome: 'slow_down_and_review'
)

# Recognize patterns in a new context
matches = client.intuitive_recognize(
  context: { domain: :deployment, risk: :high }
)

# Get an intuitive response for a context
intuition = client.intuit_response(context: { domain: :deployment, risk: :high })
# => { response: 'slow_down_and_review', confidence: :high, mode: :recognition }

# Register a heuristic
client.add_intuitive_heuristic(
  name: :deploy_cautiously, domain: :deployment,
  type: :if_then, rule: 'If risk is high, add review step'
)

# Stats
client.intuition_stats
```

## Runner Methods

| Method | Description |
|---|---|
| `learn_intuitive_pattern` | Learn or reinforce a context-outcome pattern |
| `intuitive_recognize` | Return all patterns matching the context above threshold |
| `intuit_response` | Best intuitive response (pattern or heuristic) |
| `reinforce_intuition` | Explicitly reinforce a specific pattern |
| `add_intuitive_heuristic` | Register a new heuristic shortcut |
| `apply_intuitive_heuristic` | Apply and record use of a heuristic |
| `reliable_intuitions` | All patterns in reliable or expert state |
| `expert_intuitions` | Expert-level patterns only |
| `update_intuition` | Decay patterns and learn from tick outcomes |
| `intuition_stats` | Pattern count, heuristic count, expert count, avg strength |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
