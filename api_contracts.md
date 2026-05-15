
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