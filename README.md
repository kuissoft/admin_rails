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

# Authentication

### Validate
API Call
```
curl -i -XPOST http://rea-rails-development.herokuapp.com/api/authentication/validate -d 'user_id=6&token=-x1wSyy68Fstzx1ZCZ_h'
```
Response
Success
```
{"name":"Jiri Kratochvil","role":"admin"}
```
Error
```
{"error":{"code":1,"message":"Authentication token expired"}}
```
```
{"error":{"code":2,"message":"Invalid authentication token"}}
```

### Device user registration

Resister user or send new code to activate new device

```
curl http://rea-rails-development.herokuapp.com/api/authentication/register -d 'phone=420xxxxxxxxx'
```

Ok, send 200
```
{}
```

```
{ error: { code: 5, message: "Wrong user parametres" } }
```

```
{ error: { code: 6, message: "Authentication sms not sent" } }
```

```
{ error: { code: 7, message: "Unknown error" } }
```

# Contacts

### Get all contacts

API Call
```
curl http://rea-rails-development.herokuapp.com/api/users/1/contacts.json?auth_token=XXX
```
Response
```
```

Create a new contact

```
curl -XPOST http://rea-rails-development.herokuapp.com/api/users/1/contacts.json?auth_token=XXX -d 'contact[contact_id]=2'
```

Accept/Decline/Remove a contact

```
curl -XPOST http://localhost:3000/api/users/1/contacts/accept?auth_token=XXX   -d 'contact_id=2'
curl -XPOST http://localhost:3000/api/users/1/contacts/decline?auth_token=XXX  -d 'contact_id=2'
curl -XDELETE http://localhost:3000/api/users/1/contacts/remove?auth_token=XXX -d 'contact_id=2'
```

Response is always 200 and `{}`

Inivte new contact

```
curl -H 'Content-Type: application/json' -X POST http://rea-rails-development.herokuapp.com/api/users/:user_id/contacts/invite?auth_token=xxxXXXX -d '{"contact":{"nickname":"Papuska", "phone":"421917328431"}}'
```
Ok, send 200
```
{"success":true, "invited_user":"{invited_user_object}"}
```
Errors:
```
{"error":"Connection already exists"}
```

```
{"error":{"user_id":["can't be blank"]}}
```

# Device create
```
curl -H 'Content-Type: application/json' -X POST http://rea-rails-development.herokuapp.com/api/devices -d '{"auth_token":"xxxxxxx","device":{"user_id":"23", "token":"fdsfdsfdsfdsf"}}'
```
If device is already registered to my account send 200
```
{}
```
If device not registered to my account, it is created a send device object
```
{"id":4,"token":"myReallySecretTokenUniq","user_id":4,"created_at":"2014-01-17T13:09:32.503Z","updated_at":"2014-01-17T13:09:32.503Z"}
```
If device errors 
```
{"error":{"token":["has already been taken"]}}
```


# Device code validation
Validate recieved validation code

```
curl http://rea-rails-development.herokuapp.com/api/authentication/validate_code -d 'phone=420xxxxxxxxx&validation_code=1234'
```

Ok, send 200
```
{"user":{"id":12,"name":null,"email":null,"phone":"+420xxxxxxxxx","auth_token":"kL2LLCmyKsbszkWzQeU7","role":"user","last_token":null,"token_updated_at":"2014-01-06T10:43:13.618Z","validation_code":null}}
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

If the token is valid the response is 200 and `{name: "Jirka Sirka", role: "[user | admin]"}`

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

# Feedbacks

User can send feedbacks

Required fields:

* feedback_type - feedback type string [feature, bug, other]
* message - text of feedback
* email - user e-mail

Optional fields:

* user_id - you can add id of user if is logged in

```
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X POST -d '{"feedback":{"message":"I have bug when starting call. No cancel button appears! Thanks.", "email":"xxxx@example.com", "feedback_type":"bug", "user_id":""}}' http://rea-rails-development.herokuapp.com/api/feedbacks
```
Ok, send 200
```
{"success":true}
```

Error:
```
{"error":{"feedback_type":["can't be blank"],"message":["can't be blank"],"email":["can't be blank"]}}
```

# Users update

User can update his name and e-mail

Required fields:
* email - user e-mail

```
curl -H 'Content-Type: application/json' -X PUT http://rea-rails-development.herokuapp.com/api/users/:id -d '{"user":{"name":"Karel Novák", "phone":"+421917328431", "email":"name@example.com", "auth_token":"VMdGAUSzUmppuoxr4CSg"}}'
```
Ok, send 200
```
{"success":true}
```

Error:
E-mail is invalid
```
{"error":{"email":["is invalid","is invalid"]}}
```
User try to change another user or invalid or expired token
```
{"error":{"code":2,"message":"Invalid authentication token"}}
```


# LOGIN

```
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X POST -d '{"email":"tomas@remoteassistant.me", "password":"asdfasdf"}' http://rea-rails-development.herokuapp.com/api/authentication
```

# GET MY CONTACTS
```
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET http://rea-rails-development.herokuapp.com/api/users/3/contacts?auth_token=pxUBQwLRbPXxEsvQnAkE
```




    