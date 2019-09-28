# Auth Service

This API only Rails application aims to show how a simple **User** and
**Account** account service can used by any platform through a REST-like
interface or using a friendly gem for Rails specifically.

One important note about this service, is that it will not actually talk
directly with end-users. It will serve other applications that are sharing a
common user base.

## Endorsement

Even though this is an authentication service, we actually don't talk directly
with end-users and because of that we don't "authenticate" them neither
"authorize" them. We just tell client apps that provided credentials are valid
or that are recognized. Right... we could use the term "authenticate", but
we want to make it evident the difference in our responsibility.

As a client application, whenever you are trying to authenticate a user you
will ask for an endorsement here. That is done by creating an **Endorsement**
resource and checking its output. If the status of created resource says it
was accepted, then you can let your user to have access to your system. If it
says it was rejected, then credentials are not valid or some other reason,
like a deactivated account, caused that.

In case of an accepted endorsement, you'll be able to see user information
as part of the response as well.

## Registration

When an application needs to sign-up a new user, we need to make sure same
user is not signing up through another application using this back-end auth
service. That's why it should be responsibility of this service to centralize
that registration process, which should happen in three steps:

  1. Create a **Registration** resource with new user information
  2. Send an email to new user using *registration token*
  3. Use token to create an **Admission** resource validating the process

When the client application gets final admission approval, it will then have
access to new user identifier for the account just created. There are edge
cases in this workflow to be considered:

  1. What if there is already a registration in process for the given email?
  2. What if there is already an account for the given email?
  3. What if the registration token is not accepted by the Admission?
  4. What if another application won admission race?

You should consider that and different statuses our API will return.
