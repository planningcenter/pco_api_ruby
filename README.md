# pco_api

`pco_api` is a Rubygem that provides a simple wrapper around our RESTful JSON api at https://api.planningcenteronline.com.

## TODO

* Doesn't yet support POST, PATCH, or DELETE requests.
* Doesn't yet support any authentication method other than HTTP Basic.

## Installation

```
gem install pco_api
```

## Usage

1. Create a new API object, passing in your credentials, e.g. `api = PCO::API.new(auth_token: 'token', auth_secret: 'secret')`
2. Chain path elements together as method calls, e.g. `api.people.v1.emails` becomes `/people/v1/emails`.
3. For IDs, treat the object like a hash (use square brackets), e.g. `api.people.v1.emails[1]` becomes `/people/v1/emails/1`.
4. To execute the request, use `get` as a kicker, e.g. `api.people.v1.emails[1].get`.

## Example

```ruby
require 'pco_api'

api = PCO::API.new(auth_token: 'token', auth_secret: 'secret')
api.people.v1.people.get(order: 'last_name')
```

...which returns something like:

```ruby
{
  "links" => {
    "self" => "https://api.planningcenteronline.com/people/v1/people?order=last_name",
    "next" => "http://api.planningcenteronline.com/people/v1/people?offset=25&order=last_name"
  },
  "data"=> [
    {
      "type" => "Person",
      "id" => "271",
      "first_name" => "Jean",
      "middle_name" => nil,
      "last_name" => "Abernathy",
      "birthdate" => "1885-01-01",
      "anniversary" => nil,
      "gender" => "F",
      "grade" => -1,
      "child" => false,
      "status" => "active",
      "school_type" => nil,
      "graduation_year" => nil,
      "site_administrator" => false,
      "people_permissions" => nil,
      "created_at" => "2015-04-01T20:18:22Z",
      "updated_at" => "2015-04-10T18:59:51Z",
      "avatar" => nil,
      "links" => {
        "self" => "http://api.pco.dev/people/v1/people/271"
      }
    },
    # ...
  ],
  "meta" => {
    "total_count" => 409,
    "count" => 25,
    "next" => {
      "offset" => 25
    },
    "orderable_by" => [
      "first_name",
      "middle_name",
      "last_name",
      "birthdate",
      "anniversary",
      "gender",
      "grade",
      "child",
      "status",
      "school_type",
      "graduation_year",
      "site_administrator",
      "people_permissions",
      "created_at",
      "updated_at"
    ],
    "filterable_by" => [
      "first_name",
      "middle_name",
      "last_name",
      "birthdate",
      "anniversary",
      "gender",
      "grade",
      "child",
      "status",
      "school_type",
      "graduation_year",
      "site_administrator",
      "people_permissions",
      "created_at",
      "updated_at"
    ],
    "can_include" => [
      "emails",
      "addresses",
      "phone_numbers",
      "households",
      "school",
      "inactive_reason",
      "marital_status",
      "name_prefix",
      "name_suffix",
      "field_data",
      "apps"
    ]
  }
}
```

## Copyright & License

Copyright 2015, Ministry Centered Technologies. Licensed MIT.
