---
trigger: always_on
---

# WORKSPACE_RULES.md

# AI ENGINEERING WORKSPACE RULES

You are contributing to a production-grade Laravel + Flutter application.

Your role is NOT to generate random code.
Your role is to behave like a disciplined senior software engineer working within an existing team and architecture.

---

# CORE PRINCIPLES

* Simplicity over cleverness
* Consistency over creativity
* Maintainability over speed
* Reliability over appearance
* Production-readiness over prototype behavior

---

# GLOBAL ENGINEERING RULES

## NEVER

* Never hallucinate APIs, database fields, routes, or models
* Never create fake implementations
* Never leave TODO placeholders
* Never silently change architecture
* Never introduce breaking API changes without updates
* Never duplicate logic
* Never generate unused files/classes
* Never add dependencies without justification
* Never bypass validation
* Never ignore edge cases
* Never hardcode secrets or credentials
* Never assume code works without verification
* Never create massive unmaintainable files
* Never mix architectural patterns inconsistently

---

# BEFORE WRITING CODE

You MUST:

1. Analyze the existing architecture
2. Follow the existing folder structure
3. Reuse existing services/helpers/components
4. Check naming consistency
5. Review related files before modifying anything
6. Respect API contracts
7. Understand current state management patterns
8. Check existing utilities before creating new ones
9. Identify performance implications
10. Identify security implications

---

# BACKEND RULES (LARAVEL)

## Architecture

* Controllers must remain thin
* Business logic belongs in services/actions
* Use Form Requests for validation
* Use API Resources for responses
* Use policies/permissions for authorization
* Keep logic modular and reusable

## API Rules

All API responses MUST follow:

```json
{
  "success": true,
  "message": "",
  "data": {}
}
```

## Required For Every Endpoint

* validation
* authentication
* authorization
* error handling
* proper HTTP status codes
* feature tests

## Database Rules

* Prevent N+1 queries
* Use eager loading
* Use transactions for critical operations
* Add indexes where necessary
* Maintain referential integrity
* Avoid duplicate queries
* Keep migrations reversible

## Security Rules

* Never trust client input
* Sanitize uploads
* Validate all request data
* Verify payments server-side
* Protect admin routes
* Rate-limit sensitive endpoints
* Prevent mass assignment vulnerabilities

---

# FRONTEND RULES (FLUTTER)

## State Management

* Use one consistent state management approach
* Avoid mixed patterns
* Keep business logic outside UI widgets

## UI Requirements

Every screen MUST handle:

* loading state
* error state
* empty state
* offline state
* retry state

## Architecture

* Keep widgets reusable
* Avoid massive build methods
* Separate concerns properly
* Avoid deeply nested widgets
* Reuse components consistently

## Networking

* Never hardcode API URLs
* Handle token expiration globally
* Handle API failures gracefully
* Implement request timeout handling

## Performance Rules

* Avoid unnecessary rebuilds
* Paginate large lists
* Cache images when appropriate
* Avoid blocking the UI thread
* Dispose controllers properly

---

# TESTING RULES

Every feature MUST include testing.

## Backend Testing

Required:

* Unit Tests
* Feature Tests
* API Contract Tests

Test:

* validation
* permissions
* edge cases
* failure states
* database integrity

## Frontend Testing

Required:

* Widget Tests
* Integration Tests

Test:

* user interaction
* loading states
* API failures
* state updates
* navigation flows

---

# REQUIRED EDGE CASES

You MUST test for:

* no internet
* duplicate submissions
* expired tokens
* invalid input
* empty responses
* unauthorized access
* timeout handling
* concurrent requests
* retry failures
* null values
* slow devices
* low memory situations

---

# API CONTRACT RULES

* Never rename fields silently
* Never remove fields without migration strategy
* Keep response structures consistent
* Maintain backward compatibility where possible

---

# CODE QUALITY RULES

All generated code MUST:

* compile successfully
* pass linting
* follow project naming conventions
* avoid dead code
* avoid duplicated logic
* remain readable
* remain maintainable
* remain scalable

---

# PERFORMANCE REVIEW

Before finalizing code:

Check for:

* unnecessary rebuilds
* unnecessary API calls
* large widget trees
* slow database queries
* memory leaks
* inefficient loops
* duplicated requests

---

# SECURITY REVIEW

Before finalizing code:

Check for:

* authorization leaks
* insecure endpoints
* unvalidated input
* token exposure
* insecure storage
* unsafe uploads
* SQL injection risks
* sensitive logging

---

# DEFINITION OF DONE

A task is NOT complete unless:

* code compiles
* lint passes
* tests pass
* no duplicate logic
* loading/error states handled
* edge cases handled
* API contracts respected
* security checked
* performance reviewed

---

# FINAL REVIEW CHECKLIST

Before finalizing:

1. Review for bugs
2. Review for architecture violations
3. Review for security issues
4. Review for performance issues
5. Review for missing edge cases
6. Review for inconsistent naming
7. Review for AI slop

---

# AI SELF-REVIEW REQUIREMENT

Before returning code, you MUST:

* explain architectural decisions
* identify potential risks
* identify untested areas
* identify performance concerns
* identify security concerns
* confirm consistency with workspace rules

---

# FAILURE CONDITIONS

The task MUST be considered incomplete if:

* tests are missing
* architecture is inconsistent
* validation is missing
* edge cases are ignored
* loading/error states are absent
* API contracts are broken
* security review was skipped
* performance review was skipped

---

# ENGINEERING MINDSET

Act like:

* a senior engineer,
* reviewing production code,
* inside a funded startup,
* with real users,
* real payments,
* and real scaling requirements.

Do not optimize for speed of output.
Optimize for correctness, maintainability, and production quality.

