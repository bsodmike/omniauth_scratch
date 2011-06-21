# Multi-Auth

This is based on implementing Omniauth thanks to the excellent two-part Railscasts on Omniauth ([Part 1](http://railscasts.com/episodes/235-omniauth-part-1), [Part 2](http://railscasts.com/episodes/236-omniauth-part-2)) by Ryan Bates with a twist — integrated with [authentication from scratch](http://railscasts.com/episodes/250-authentication-from-scratch) rather than Devise.

## Authentication — How it works...

The app allows users to either authenticate (and create a user with an associated authentication) or sign up for an account with password access.  This concept has been built upon as

* If a user authenticates against a service and later signs up for a regular account, re-authentication will merge the authentication with the current user account and delete the prior account.  The prior account is deleted as a measure to ensure that email isn't taken up in the app as this is validated for uniqueness in its model.
* New accounts created as a result of simply authenticating with a service are subjected to model validations and prompts for an email address — the password and password_hash fields remain as nil.
* Accounts only created against an authentication are only allowed to delete their authentication if they have more than one (as their password & hash are nil)
* Since the password/hash fields are nil for accounts created purely against an authentication, logging in with just the email (blank password & confirmation) raises a `BCrypt::Errors::InvalidSalt` exception.  This is rescued to route to the sign up path with an appropriate message.
* Logged in users are correctly handled if they attempt to visit `/sign_in` or `/sign_up`.

### Routes
Here are the important routes — to give one a sense of the various controllers and actions in play.

```ruby
                           /auth/:provider/callback(.:format)  {:controller=>"authentications", :action=>"create"}
       auth_failure        /auth/failure(.:format)             {:controller=>"authentications", :action=>"failure"}
           sign_out        /sign_out(.:format)                 {:controller=>"sessions", :action=>"destroy"}
            sign_in        /sign_in(.:format)                  {:controller=>"sessions", :action=>"new"}
            sign_up        /sign_up(.:format)                  {:controller=>"users", :action=>"new"}
               root        /(.:format)                         {:controller=>"authentications", :action=>"index"}
```

## Acknowledgements
Here's thanking those that have inspired and assisted, in no particular order.

* Ryan Bates
* workmad3
* SpaceGhostSC
* samuelkadolph
* sheldonh
* #RubyOnRails 
* ...anyone I may have forgotten to mention.

## License
Auth is licensed under the MIT License.