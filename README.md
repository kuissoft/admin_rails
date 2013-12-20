x
Backend
=======

API
---

# Error codes

```
{
  TOKEN_EXPIRED: 1,
  INVALID_TOKEN: 2,
  NOT_AUTHENTICATED: 3,
  ASSISTANT_BUSY: 4,
  WRONG_PARAMETERES: 5,
  EMAIL_NOT_SENT: 6,
  UNKNOWN_ERROR: 7,
  NOT_MATCH: 8,
  NO_VALIDATION_CODE: 9,
  USER_NOT_EXISTS: 10

}
```

# Contacts

Get all contacts

```
curl http://remoteassistant-backend-test.herokuapp.com/api/users/1/contacts.json?auth_token=XXX
```

Create a new contact

```
curl -XPOST http://remoteassistant-backend-test.herokuapp.com/api/users/1/contacts.json?auth_token=XXX -d 'contact[contact_id]=2'
```

Accept/Decline/Remove a contact

```
curl -XPOST http://localhost:3000/api/users/1/contacts/accept?auth_token=XXX   -d 'contact_id=2'
curl -XPOST http://localhost:3000/api/users/1/contacts/decline?auth_token=XXX  -d 'contact_id=2'
curl -XDELETE http://localhost:3000/api/users/1/contacts/remove?auth_token=XXX -d 'contact_id=2'
```

Response is always 200 and `{}`

# Authentication

```
curl -XPOST http://localhost:3000/api/authentication -d email=tomas@remoteassistant.me&password=asdfasdf
```

The token is only valid for 1 day. If the user tries to authenticate
with an expired token, he will receive the following response.

```
{"error":{"code":1,"message":"Authentication token expired"}}
```

# Device registration

Resister user or send new code to activate new device

```
curl http://localhost:3000/api/authentication/register -d 'email=name@example.com'
```

Ok, send 200
```
{}
```

```
{ error: { code: 5, message: "Wrong user parametres" } }
```

```
{ error: { code: 6, message: "Authentication e-mail not sent" } }
```

```
{ error: { code: 7, message: "Unknown error" } }
```

# Device code validation
Validate recieved validation code

```
curl http://rea-rails-development.herokuapp.com/api/authentication/validate_code -d 'email=name@example.com&validation_code=1234'
```

Ok, send 200
```
{auth_token: xxXX}
```

```
{ error: { code: 8, message: "Validation code not match" } }
```

```
{ error: { code: 9, message: "User has no validation code generated" } }
```

```
{ error: { code: 10, message: "User not exists" } }
```

# Token validation

A user can validate his token

```
curl -i -XPOST http://rea-rails-development.herokuapp.com/api/authentication/validate -d 'user_id=6&token=-x1wSyy68Fstzx1ZCZ_h'
```

If the token is valid the response is 200 and `{}`

If the token is expired

```
{"error": {"code": TOKEN_EXPIRED, "message":"Authentication token expired"} }
```

If the token is invalid

```
{"error":{"code": INVALID_TOKEN, "message":"Invalid authentication token"}}
```

He then has to authenticate again with username and password and get a
new token.

# REGISTER

```
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X POST -d '{"user":{"name":"Tomas Stanik", "phone":"+421917328431", "email":"tomas@remoteassistanx.me", "password":"asdfasdf"}}' http://remoteassistant-backend-test.herokuapp.com/api/users
```

# LOGIN

```
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X POST -d '{"email":"tomas@remoteassistant.me", "password":"asdfasdf"}' http://remoteassistant-backend-test.herokuapp.com/api/authentication
```

# GET MY CONTACTS
```
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET http://remoteassistant-backend-test.herokuapp.com/api/users/3/contacts?auth_token=pxUBQwLRbPXxEsvQnAkE
```
