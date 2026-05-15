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