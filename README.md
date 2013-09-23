Backend
=======

API
---

# Contacts

Get all contacts or a user

```
curl http://remoteassistant-backend-test.herokuapp.com/api/users/1/contacts.json
```

REGISTER
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X POST -d '{"user":{"name":"Tomas Stanik", "phone":"+421917328431", "email":"tomas@remoteassistanx.me", "password":"asdfasdf"}}' http://remoteassistant-backend-test.herokuapp.com/api/users

LOGIN
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X POST -d '{"email":"tomas@remoteassistant.me", "password":"asdfasdf"}' http://remoteassistant-backend-test.herokuapp.com/api/authentication

GET MY CONTACTS
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET http://remoteassistant-backend-test.herokuapp.com/api/users/3/contacts?auth_token=pxUBQwLRbPXxEsvQnAkE

### Sessions ###

GET ALL SESSIONS
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET http://remoteassistant.herokuapp.com/api/sessions
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET http://localhost:3000/api/sessions

GET MY SESSION (sender)
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET -d '{"session":{"sender_id":2}}' http://remoteassistant.herokuapp.com/api/sessions
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET -d '{"session":{"sender_id":12}}' http://localhost:3000/api/sessions

GET MY SESSION (recipient)
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET -d '{"session":{"recipient_id":2}}' http://remoteassistant.herokuapp.com/api/sessions
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET -d '{"session":{"recipient_id":12}}' http://localhost:3000/api/sessions

CREATE SESSION
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X POST -d '{"session":{"sender_id":1, "recipient_id":2}}' http://remoteassistant.herokuapp.com/api/sessions
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X POST -d '{"session":{"sender_id":11, "recipient_id":12}}' http://localhost:3000/api/sessions

DELETE SESSION
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X DELETE http://remoteassistant.herokuapp.com/api/sessions/2
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X DELETE http://localhost:3000/api/sessions/2

### Locations ###

GET ALL LOCATIONS
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET http://remoteassistant.herokuapp.com/api/locations
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET http://localhost:3000/api/locations

GET SESSION LOCATION
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET -d '{"location":{"session_id":4}}' http://remoteassistant.herokuapp.com/api/locations
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET -d '{"location":{"session_id":56}}' http://localhost:3000/api/locations

CREATE / UPDATE LOCATION
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X POST -d '{"location":{"session_id":4, "lat":0.1, "lon":0.2, "bearing":3}}' http://remoteassistant.herokuapp.com/api/locations
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X POST -d '{"location":{"session_id":56, "lat":0.1, "lon":0.2, "bearing":3}}' http://localhost:3000/api/locations
