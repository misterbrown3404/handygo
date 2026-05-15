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
