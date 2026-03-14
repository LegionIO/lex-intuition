# lex-intuition

**Level 3 Leaf Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Gem**: `lex-intuition`
- **Version**: `0.1.0`
- **Namespace**: `Legion::Extensions::Intuition`

## Purpose

Pattern recognition and heuristic-based intuitive reasoning for LegionIO agents. Learns patterns from repeated context/outcome pairs, matches new contexts against known patterns via overlap scoring, applies registered heuristics as fast cognitive shortcuts, and provides confidence-labeled intuitive responses. Distinguishes reliable patterns (strength >= 0.65, encounters >= 3) from expert patterns (strength >= 0.85, encounters >= 10).

## Gem Info

- **Require path**: `legion/extensions/intuition`
- **Ruby**: >= 3.4
- **License**: MIT
- **Registers with**: `Legion::Extensions::Core`

## File Structure

```
lib/legion/extensions/intuition/
  version.rb
  helpers/
    constants.rb          # Limits, thresholds, labels, modes, types
    pattern.rb            # Pattern value object with match scoring
    heuristic.rb          # Heuristic value object with outcome tracking
    intuition_engine.rb   # In-memory pattern + heuristic store
  runners/
    intuition.rb          # Runner module

spec/
  legion/extensions/intuition/
    helpers/
      constants_spec.rb
      pattern_spec.rb
      heuristic_spec.rb
      intuition_engine_spec.rb
    runners/intuition_spec.rb
  spec_helper.rb
```

## Key Constants

```ruby
MAX_PATTERNS          = 200
MAX_HEURISTICS        = 50
RECOGNITION_THRESHOLD = 0.6   # minimum match_score to count as recognition
REINFORCEMENT_RATE    = 0.1   # strength increment per reinforce call

PATTERN_STATES = %i[forming reliable expert decaying]

HEURISTIC_TYPES = %i[
  if_then analogy prototype exemplar threshold contrast
  availability representativeness anchoring
]

INTUITION_MODES = %i[recognition heuristic hybrid exploratory]

CONFIDENCE_LABELS = {
  (0.8..)     => :very_high,
  (0.6...0.8) => :high,
  (0.4...0.6) => :moderate,
  (0.2...0.4) => :low,
  (..0.2)     => :very_low
}

STATE_THRESHOLDS = { reliable: { strength: 0.65, encounters: 3 },
                     expert:   { strength: 0.85, encounters: 10 } }
```

## Helpers

### `Helpers::Pattern` (class)

A learned context-outcome pair that can be recognized in new situations.

| Attribute | Type | Description |
|---|---|---|
| `id` | String (UUID) | unique identifier |
| `context` | Hash | the recognizable context signature |
| `outcome` | String | predicted outcome when context is matched |
| `strength` | Float (0..1) | pattern confidence |
| `encounters` | Integer | recognition events |
| `state` | Symbol | :forming / :reliable / :expert / :decaying |

Key methods:
- `match_score(new_context)` — Jaccard-style overlap of context key sets divided by max set size; float 0..1
- `reinforce` — strength += REINFORCEMENT_RATE (cap 1.0), increment encounters, update state
- `decay` — strength -= 0.01 per decay tick; transitions to :decaying below threshold
- `reliable?` — strength >= 0.65 && encounters >= 3
- `expert?` — strength >= 0.85 && encounters >= 10

### `Helpers::Heuristic` (class)

A fast cognitive shortcut for a given domain.

| Attribute | Type | Description |
|---|---|---|
| `id` | String (UUID) | unique identifier |
| `name` | Symbol | heuristic name |
| `domain` | Symbol | applicable domain |
| `heuristic_type` | Symbol | from HEURISTIC_TYPES |
| `rule` | String | the heuristic rule text |
| `uses` | Integer | application count |
| `successes` | Integer | successful outcome count |

Key methods:
- `apply` — increments uses
- `record_outcome(success:)` — increments successes if true
- `success_rate` — successes / uses (nil if uses == 0)
- `effective?` — uses >= 3 && success_rate >= 0.6

### `Helpers::IntuitionEngine` (class)

Combined pattern + heuristic store.

| Method | Description |
|---|---|
| `learn_pattern(context:, outcome:)` | stores new pattern or reinforces existing match |
| `recognize(context:)` | returns patterns with match_score >= RECOGNITION_THRESHOLD |
| `intuit(context:)` | best recognition hit or first effective heuristic; returns intuition hash |
| `reinforce_pattern(id:)` | explicit pattern reinforcement |
| `add_heuristic(name:, domain:, type:, rule:)` | registers new heuristic |
| `apply_heuristic(id:)` | applies heuristic and increments uses |
| `reliable_patterns` | patterns in :reliable or :expert state |
| `expert_patterns` | patterns in :expert state |
| `decay_all` | decays all patterns; removes those below floor |

## Runners

Module: `Legion::Extensions::Intuition::Runners::Intuition`

Private state: `@engine` (memoized `IntuitionEngine` instance).

| Runner Method | Parameters | Description |
|---|---|---|
| `learn_intuitive_pattern` | `context:, outcome:` | Learn or reinforce a pattern |
| `intuitive_recognize` | `context:` | Return matching patterns above recognition threshold |
| `intuit_response` | `context:` | Best intuition (pattern or heuristic) for context |
| `reinforce_intuition` | `id:` | Reinforce a specific pattern |
| `add_intuitive_heuristic` | `name:, domain:, type:, rule:` | Register a new heuristic |
| `apply_intuitive_heuristic` | `id:` | Apply a heuristic |
| `reliable_intuitions` | (none) | All reliable patterns |
| `expert_intuitions` | (none) | Expert-level patterns only |
| `update_intuition` | `tick_results: {}` | Decay patterns; learn from tick outcomes |
| `intuition_stats` | (none) | Pattern count, heuristic count, expert count, avg strength |

## Integration Points

- **lex-emotion**: `gut_instinct` in lex-emotion provides the fast valence signal; lex-intuition provides the pattern-matched cognitive signal for the same gut response.
- **lex-prediction**: prediction uses forward reasoning; intuition uses pattern matching. Both feed `action_selection` with complementary signals.
- **lex-tick**: `intuit_response` is called in `gut_instinct` or `action_selection` phases to provide pattern-based bias.
- **lex-metacognition**: `Intuition` is listed under `:cognition` capability category.

## Development Notes

- `match_score` uses set intersection/union of context keys (not values). Two contexts with identical keys but different values will still score 1.0. Value comparison is not implemented.
- `learn_pattern` checks for existing patterns with match_score >= RECOGNITION_THRESHOLD before creating a new one. If a match is found, the existing pattern is reinforced instead of creating a duplicate.
- `intuit` returns the highest-scoring pattern recognition hit; if no patterns score above threshold, it falls through to the first effective heuristic. If neither applies, it returns a low-confidence exploratory response.
- Decay is triggered by `update_intuition` each tick. Patterns below 0.05 strength are removed.
- Heuristics do not decay — they accumulate uses and are only removed if the store exceeds MAX_HEURISTICS (LRU by last_used).
