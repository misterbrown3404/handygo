# FLUTTER RULES

STATE MANAGEMENT:
- Use GetX consistently.
- No mixed state management approaches.

UI RULES:
- Handle:
  - loading
  - empty
  - error
  - offline
  states on every screen.

ARCHITECTURE:
- Keep widgets reusable.
- Avoid massive build methods.
- Separate UI from business logic.

NETWORKING:
- Never hardcode API URLs.
- Use repository/service layer.
- Handle token expiration globally.

PERFORMANCE:
- Avoid unnecessary rebuilds.
- Paginate large lists.
- Cache images where needed.

REQUIRED BEFORE COMPLETION:
- flutter analyze
- widget tests
- integration tests