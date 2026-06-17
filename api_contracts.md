
# API CONTRACTS

LOGIN RESPONSE

{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "",
    "user": {
      "id": 1,
      "name": "",
      "email": ""
    }
  }
}

RULES:
- Never rename fields silently.
- Never remove fields without migration strategy.
- Maintain consistent response format.


# LARAVEL BACKEND RULES

- Use Service Layer pattern.
- Controllers must stay thin.
- Business logic belongs in services.
- Validate all requests using Form Requests.
- Use API Resources for responses.
- Standardize JSON responses.

API RESPONSE FORMAT:

{
  "success": true,
  "message": "",
  "data": {}
}

REQUIRED FOR EVERY ENDPOINT:
- authentication check
- authorization policy
- validation
- error handling
- feature test

DATABASE RULES:
- avoid N+1 queries
- eager load relationships
- add indexes where needed
- use transactions for critical operations

SECURITY:
- never trust client input
- sanitize uploads
- verify payments server-side
# ENGINEERING RULES

You are working on a production-grade Laravel + Flutter application.

GLOBAL REQUIREMENTS:

- Never generate fake implementations.
- Never leave TODO placeholders.
- Never hallucinate APIs or database fields.
- Never generate untested code.
- Always prefer simple architecture over abstraction.
- Follow existing folder structure strictly.
- Avoid duplicate logic.
- Every feature must include:
  - validation
  - loading state
  - error handling
  - empty state
  - edge-case handling
  - tests

BEFORE WRITING CODE:
- Analyze existing architecture.
- Reuse existing services/helpers/components.
- Check for naming consistency.
- Check API contracts.

AFTER WRITING CODE:
- Run linting.
- Run tests.
- Check performance implications.
- Check security implications.

NEVER:
- change response structures without updating contracts
- introduce breaking changes silently
- generate massive files unnecessarily
- create unused classes
- add packages without justification


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

# TESTING RULES

Every feature must include tests.

BACKEND:
- Unit tests
- Feature tests
- API contract tests

FRONTEND:
- Widget tests
- Integration tests

MANDATORY EDGE CASES:
- no internet
- duplicate submission
- invalid data
- timeout
- unauthorized access
- empty responses

A feature is NOT complete until tests pass.