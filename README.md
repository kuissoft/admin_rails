Backend
=======

API
---

# Error codes

```
{
    0 100    UNDEFINED_ERROR          Undefined error
    0 101    VALIDATION_ERROR 
    0 102    TOKEN_EXPIRED          Authentication token expired
    0 103    INVALID_TOKEN          Invalid authentication token
    0 104    NOT_AUTHENTICATED
    0 105    ASSISTANT_BUSY
    0 106    WRONG_PARAMETERES      Wrong user parametres
    0 107    AUTH_SMS_NOT_SENT      Authentication SMS not sent
    0 108    CONNECTION_EXISTS      Connection already exists
    0 109    NOT_MATCH
    0 110    NO_VALIDATION_CODE
    0 111    USER_NOT_EXISTS
    0 112    USER_ID_BLANK          User ID can't be blank
    0 113    URL_NOT_FOUND         Url not found
    0 114    RESEND_LIMIT_REACHED        Resend limit reached
    0 115    DEVICE_NOT_EXISTS  
    0 116    UUID_EXISTS          UUID already exist    
    0 117    PENDING_CONNECTION_NOT_EXISTS Pending Connection does not exist    
    0 118    CONNECTION_NOT_EXISTS          Connection does not exist    
    
}
```

# Versioning

Please specify V1 or V2 uri, if not it uses default API

# DEFAULT API: V1

# Device

### Authenticate

Authenticate new device and send new verification code

#### Parameters
* {String} phone
* {String} uuid
* {String} language - [en, cs, sk]

API Call
```
curl -XPOST http://dev.api.remoteassistant.me/devices/authenticate -d 'phone=420xxxxxxxxx&uuid=3s2d4fd2f4fd2&language=en'
```

Ok, send 200
```
{}
```
Errors:
```
{ error_info: { code: 116, message: "Device authentication wasn't successful" } }
```

```
{ error_info: { code: 106, message: "Cannot send verification SMS. Please try again later." } }
```

```
{ error_info: { code: 100, title: 'UNDEFINED ERROR', message: '' } }
```

### Deauthenticate

Deauthentificate user's device

#### Parameters
* {String} user_id
* {String} uuid
* {String} auth_token

API Call
```
curl http://dev.api.remoteassistant.me/devices/deauthenticate -d 'user_id=1&uuid=3s2d4fd2f4fd2&auth_token=xxxXXX'
```

Ok, send 200
```
{}
```
Errors:
```
{"error_info":{"code": 102, title: '', message: 'Authentication token does not match.'}}
```

```
{"error_info":{"code":104,"title":"","message":"Device not authenticated."}}
```

```
{ error_info: { code: 100, title: 'UNDEFINED ERROR', message: '' } }
```

### Validate

Validate device from Node server

#### Parameters
* {String} user_id
* {String} uuid
* {String} auth_token
* {String} connection_type - ['Unknown', 'GPRS', 'Edge', '3G', '4G', 'LTE', 'Wi-Fi']

API Call
```
curl -i -XPOST http://dev.api.remoteassistant.me/devices/validate -d 'user_id=6&auth_token=-x1wSyy68Fstzx1ZCZ_h&uuid=fsdfdsfsf&connection_type=Wi-Fi'
```
Response

Ok, sends 200
```
{"name":"Jiri Kratochvil","role":"admin", "uuid":"fsdfdsgfgdfgfdg"}
```
Errors:
```
{"error_info":{"code": 102, title: '', message: 'Authentication token does not match.'}}
```

```
{"error_info":{"code":104,"title":"","message":"Device not authenticated."}}
```

### Verify code

Verify recieved verification code

#### Parameters
* {String} phone
* {String} uuid
* {String} verification_code

API Call

```
curl http://dev.api.remoteassistant.me/devices/verify_code -d 'phone=420xxxxxxxxx&verification_code=1234&uuid=fsdfdsfsf'
```

Ok, send 200
```
{"user":{"id":3,"name":"Jiří Kratochvíl","email":"jiri@remoteassistant.me","phone":"+420720733688","role":"admin","auth_token":"bbb","last_token":"","token_updated_at":"2014-04-30T11:36:00.000+02:00","photo_url":null}}
```
Errors:
```
{ error_info: { code: 109, title: '', message: 'Verification code does not match.' } }
```

```
{ error_info: { code: 110, title: '', message: 'No verification code.' } }
```

```
{ error_info: { code: 115, title: '', message: 'Device does not exist'} }

```

### Resend verification code

Resend verification code

#### Parameters
* {String} phone
* {String} uuid

API Call

```
curl http://dev.api.remoteassistant.me/devices/resend_code -d 'phone=420xxxxxxxxx&uuid=fsdfdsfsf'
```

Ok, send 200
```
{}
```

Errors:
```
{ error_info: { code: 114, title:'', message: 'Resend Verification code limit reached' } }, status: 401
```

```
{ error_info: { code: 106, title:'', message: sms.last } }, status: 401
```

```
{ error_info: { code: 111, title: '', message: 'User does not exists' } }
```

```
{ error_info: { code: 115, title: '', message: 'Device does not exist'} }

```

### Set APNS Token

Set APNS Token

#### Parameters
* {String} user_id
* {String} auth_token
* {String} uuid
* {String} device[apns_token]

API Call

```
curl -H 'Content-Type: application/json' -X POST http://dev.api.remoteassistant.me/devices/set_apns_token -d '{"user_id":"23", "auth_token":"xxxxxxx", "uuid":"dfsfdsf", device":{ "apns_token":"fdsfdsfdsfdsf"}}'
```

Response

Ok, send 200
```
{}
```

Errors:

```
{"error_info":{"code": 102, title: '', message: 'Authentication token does not match.'}}
```

```
{"error_info":{"code":104,"title":"","message":"Device not authenticated."}}
```

# Calls
### Get call info !!ONLY WHEN NOTIFICATION IS SENT!!
API Call
```
curl http://dev.api.remoteassistant.me/calls\?call_id=Ul2jrfWYQG8QsQ2RoTqbzA
```
Response

Ok, send 200
```
{"assistant_token":"dsfsdf","assistant_id":"4","caller_id":"1","session_id":"adafa","format":"json","action":"create","controller":"api/v1/notifications","notification":{"assistant_token":"T1==cGFydG5l","assistant_id":"4","caller_id":"1","session_id":"1_MX4zODgy"}}
```

Errors:
```
{"error_info":{"code":101,"message":"Invalid call id"}}
```

### Dummy Call

API Call
```
curl -XGET http://dev.api.remoteassistant.me/v2/calls/dummy_call
```

Response

Ok, send 200
```
{"session_id":"2_MX4zODgyODg0Mn4xMjcuMC4wLjF-VHVlIEFwciAyOSAwOToyNDowMiBQRFQgMjAxNH4wLjg0NzgwMTU3flB-","caller_token":"T1==cGFydG5lcl9pZD0z","assistant_token":"T1==cGFydG5lcl9pZD0zODgyOD"}
```

# Contacts

### Get all contacts

API Call
```
curl http://dev.api.remoteassistant.me/users/1/contacts.json?auth_token=XXX&uuid=fsdfdsfsf
```
Response

#### Photo sizes:

* _original
* _x50
* _x100
* _x150
* _x300

Ok, sends 200
```
{"contacts":[{"id":33,"name":null,"email":null,"phone":"+420602302314","is_pending":true,"is_rejected":false,"is_removed":false, "nickname":"Jirka","last_online":"2014-03-10T14:47:55.633Z","is_online":true,"connection_type":"edge","photo_url":"http://localhost:3000/images/photos/users/1/1394531141"}]}
```

Errors:
```
{"error":"You need to sign in or sign up before continuing."}
```

### Inivte new contact
API Call
```
curl -H 'Content-Type: application/json' -X POST http://dev.api.remoteassistant.me/users/:user_id/contacts/invite?auth_token=xxxXXXX&uuid=fsdfdsfsf -d '{"contact":{"nickname":"Papuska", "phone":"421917328431"}}'
```
Response

Ok, send 200
```
{{"invited_user":{"id":34,"name":null,"phone":"+420602302314","nickname":"Papuska Moja"}}}
```
Errors:
```
{"error_info":{"code":108, title: '', message: 'Connection already exists'}}
```

```
{ error_info: { code: 101, message: "User_id blablabla cant be blank, Contact_id cant be blank..." } }
```

### Accept/Decline/Remove a contact
API Call

Accept
```
curl -XPOST http://dev.api.remoteassistant.me/users/1/contacts/accept?auth_token=XXX&uuid=fsdfdsfsf   -d 'contact_id=2'
```
Decline
```
curl -XPOST http://dev.api.remoteassistant.me/users/1/contacts/decline?auth_token=XXX&uuid=fsdfdsfsf  -d 'contact_id=2'
```
Remove
```
curl -XDELETE http://dev.api.remoteassistant.me/users/1/contacts/remove?auth_token=XXX&uuid=fsdfdsfsf -d 'contact_id=2'
```
Dismiss
```
curl -XDELETE http://dev.api.remoteassistant.me/users/1/contacts/remove?auth_token=XXX&uuid=fsdfdsfsf -d 'contact_id=2'
```
Response 

Ok, send 200 
```
{}
```

### Cancel Invitation
API Call

Cancel Invitation
```
curl -XDELETE http://dev.api.remoteassistant.me/users/:user_id/contacts cancel_invitation?contact_id=2&auth_token=bbb&uuid=aaa
```

Response 

Ok, send 200 
```
{}
```

Errors:
```
{ errors_info: {code: 101, title: '', messages: "#{connection.errors.full_messages.join(", ")}"} }
```

```
{ error_info: { code: 117, title: '', message: 'Pending invitation can not be removed' } }
```

### Update contact
API Call
```
curl -H 'Content-Type: application/json' -X PUT http://dev.api.remoteassistant.me/users/:user_id/contacts/:id?auth_token=xxxXXX&uuid=fsdfdsfsf -d '{"contact":{"nickname":"Bossak"}}'
```
Response 

Ok, send 200 
```
{"contact":{"id":1,"name":"Tomas Stanik","email":"tomas@remoteassistant.me","phone":"+420606484899","is_pending":true,"is_rejected":false,"is_removed":false,"nickname":"Bossakovo"}}
```
Errors:
```
{ errors_info: {code: 101, title: '', messages: "#{connection.errors.full_messages.join(", ")}"} }
```
```
{ error_info: { code: 111, title: '', message: 'User not exists' } }
```

# Notifications

### Get all notifications for user
API call
```
curl http://dev.api.remoteassistant.me/notifications?user_id=4&auth_token=xxxXXX&uuid=fsdfdsfsf
```

Responds

Ok, send 200
```
{"notifications":[{"type":"invitation","user":{"id":1,"name":"Tomas Stanik"}},{"type":"invitation","user":{"id":2,"name":"Jana Filova"}},{"type":"rejection","user":{"id":3,"name":"Jakub Arnold"}},{"type":"rejection","user":{"id":13,"name":"Petr Novák"}},{"type":"removal","user":{"id":11,"name":"E"}},{"type":"removal","user":{"id":12,"name":"F"}}]}
```

Errors:
```
{ "error_info": { "code": 111, title: '', message: 'User not exists'} }
```
### Change device language
API call
```
curl -H 'Content-Type: application/json' -X PUT http://localhost:3000/api/devices/change_language -d '{"phone":"+420720733688","uuid":"fsfdsfdsf", "language":"cs"}'
```
Responds

Ok, send 200
```
{}
```

Errors:
```
{ "error_info": { "code": 115, title: '', message: 'Device not exists'} }
```
# Feedbacks

User can send feedbacks

Required fields:

* feedback_type - feedback type string [feature, bug, other]
* message - text of feedback
* user_id - user id of logged user


```
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X POST -d '{"feedback":{"message":"I have bug when starting call. No cancel button appears! Thanks.", "feedback_type":"bug", "user_id":"4"}}' http://dev.api.remoteassistant.me/feedbacks
```
Response

Ok, send 200
```
{}
```

Error:
```
{"error_info":{"code":101,"message": "feedback_type can't be blank , message can't be blank"}}
```
# Users update

User can update his name and e-mail

Required fields:
* email - user e-mail

```
curl -H 'Content-Type: application/json' -X PUT http://dev.api.remoteassistant.me/users/:id -d '{"uuid": "fdsfdsfds", "user":{"name":"Karel Novák", "phone":"+421917328431", "email":"name@example.com", "auth_token":"VMdGAUSzUmppuoxr4CSg"}}'
```


# Avatar upload
```
curl -H 'Content-Type: application/json' -X PUT http://dev.api.remoteassistant.me/users/:id -d '{"uuid": "fdsfdsfds", "user":{"photo":"Image Object", "auth_token":"VMdGAUSzUmppuoxr4CSg"}}'
```

# Avatar remove
```
curl -H 'Content-Type: application/json' -X PUT http://dev.api.remoteassistant.me/users/:id/remove_photo -d '{"uuid": "fdsfdsfds", "auth_token":"WtcEvb-uF819dwCsiocg"}'
```

Ok, send 200
```
{}
```

Error:
E-mail is invalid
```
{"error_info":{"code": 101, "message":"email is invalid"]}}
```
User try to change another user or invalid or expired token
```
{"error_info":{"code":103, title: '',  message: "Invalid authentication token" }}
```





    