# Shared Account and Identity Provider - shacip

**Internal REST service managing users and organizations shared by different applications**

[![CircleCI](https://circleci.com/gh/rafaelpivato/shacip.svg?style=svg)](https://circleci.com/gh/rafaelpivato/shacip) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/7448ac4940b94f4fb3b330e431d21498)](https://www.codacy.com/manual/rafaelpivato/shacip?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=rafaelpivato/shacip&amp;utm_campaign=Badge_Grade) [![Codacy Badge](https://api.codacy.com/project/badge/Coverage/7448ac4940b94f4fb3b330e431d21498)](https://www.codacy.com/manual/rafaelpivato/shacip?utm_source=github.com&utm_medium=referral&utm_content=rafaelpivato/shacip&utm_campaign=Badge_Coverage) [![Inline docs](http://inch-ci.org/github/rafaelpivato/shacip.svg?branch=master)](http://inch-ci.org/github/rafaelpivato/shacip)

This serves as a simple REST application to be used internally by different Web
applications to share a common users and organizations base. **Shacip** will not be
talking with end-users directly, not even submitting emails for confirmation,
nor providing them any password reset token or even authentication tokens.

One important note about this service, is that, besides not talking directly
with end-users, you should not expose it to the Internet. You must keep it
behind some firewall or restrict access to it somehow. In the future it might
get some API token support to let us manage whose applications can access
the service. When that happens we could expose it to public networks.

## Endorsement

Your back-end application will ask for an endorsement when it is about to
authenticate a client against this user base. That is done by creating an
**Endorsement** resource and checking its output. Note that HTTP status code
will be valid even if the credentials are not. That's because an endorsement
resource gets created anyway.

```console
$ http :3001/endorsements email=john@example.com password=johndoe
{
  "data": {
    "status": "accepted",
    ...
  }
}
```

If above status is `recognized` then you can authenticate the user. In case it
is `unknown` you should not grant user access because we don't recognize
provided credentials. There is a third status `inactive` that will be used when
we do recognize credentials but the user login is not active for some reason.
As part of a positive response, be it _recognized_ or _inactive_, you will
receive as well user information.

## Registration

When your back-end application needs to handle new user sign-up, it should
create a **Registration** resource. It is your application responsibility to
confirm end-user email address and continue with the process by updating such
**Registration** object indicating it was confirmed. These are three steps for
a common workflow:

1.  Create a **Registration** resource with new user information
2.  Send an email to new user to confirm the address
3.  Update **Registration** resource telling the address was confirmed

```console
$ http :3001/registrations email=john@example.com password=johndoe
{
  "data": {
    "id": 1234,
    "confirmed": null,
    ...
  }
}
$ http PATCH :3001/registrations/1234 confirmed=cmd.example.com
{
  "data": {
    "id": 1234,
    "confirmed": "cmd.example.com",
    ...
  }
}
```

When you confirm the registration, an user record and an organization will be
created for the user with the credentials provided during registration time.
While sending an email to the new user, you will most likely wish to encode
something like a JWT token containing the registration id from this system.

## Client Library

While using this service from another Rails or Ruby application, you should
preferably use [Shacip Ruby](https://github.com/rafaelpivato/shacip-ruby) gem
as your client library. That should help you adhering to minor changes made on
the service in a more controlled fashion. Here is a simplified workflow:

```ruby
require 'shacip-client'

# Configure the client
Shacip::Client.configure do |config|
  config.server_url = 'http://localhost:3001'
  config.app_name = 'myapp.example.com'
end

# Register against Shacip
credentials = { email: 'john@example.com', password: 'johndoe' }
registration = Registration.create(credentials)
Registration.confirm(registration.id)

# Endorses user credential
endorsement = Endorsement.create(credentials)
puts "Let user #{endorsement.user.name} sign in" if endorsement.recognized
```
