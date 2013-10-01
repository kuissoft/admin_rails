Backend
=======

API
---

# Contacts

Get all contacts or a user

```
curl http://remoteassistant-backend-test.herokuapp.com/api/users/1/contacts.json?auth_token=XXX
```

Create a new contact
```
curl -XPOST http://remoteassistant-backend-test.herokuapp.com/api/users/1/contacts.json?auth_token=XXX -d 'contact[contact_id]=2'
```

# Authentication

```
curl -XPOST http://localhost:3000/api/authentication -d email=tomas@remoteassistant.me&password=asdfasdf
```

The token is only valid for 1 day. If the user tries to authenticate
with an expired token, he will receive the following response.

```
{"error":{"code":1,"message":"Authentication token expired"}}
```

He then has to authenticate again with username and password and get a
new token.

REGISTER
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X POST -d '{"user":{"name":"Tomas Stanik", "phone":"+421917328431", "email":"tomas@remoteassistanx.me", "password":"asdfasdf"}}' http://remoteassistant-backend-test.herokuapp.com/api/users

LOGIN
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X POST -d '{"email":"tomas@remoteassistant.me", "password":"asdfasdf"}' http://remoteassistant-backend-test.herokuapp.com/api/authentication

GET MY CONTACTS
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET http://remoteassistant-backend-test.herokuapp.com/api/users/3/contacts?auth_token=pxUBQwLRbPXxEsvQnAkE
