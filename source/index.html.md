---
title: WorkCompass API Reference

language_tabs:
  - shell
  - ruby

toc_footers:

includes:
  - errors

search: true
---

# Introduction

```shell
curl -H "Content-Type: application/vnd.api+json" -H "Accept: application/vnd.api+json; version=2"
```

```ruby
request.content_type = "application/vnd.api+json"
request["Accept"] = "application/vnd.api+json; version=2"
```

The WorkCompass API allows you to write applications which can access
WorkCompass data. It is organised around REST and expects data in the [JSON
API](http://jsonapi.org) format. Authentication is handled via an access token over
HTTPS and HTTP responses and JSON API error objects are used to indicate errors.

Because all communication is via JSON API formatted JSON, the
`application/vnd.api+json` mime type must be specified in in `Content-Type` and
`Accept` HTTP headers (see example in sidebar).

The API will default to the latest version of the API available unless you
specify a version in the `Accept` header. The current is version `2` but that
may change in the future.

Currently the API supports creating, updating and archiving people records.
These operations can be performed one at a time or multiple people records can
be manipulated in one request.

# Authentication

```shell
curl -H "Authorization: Token token=abcd1234"
```

```ruby
request["Authorization"] = "Token token=abcd1234"
```

All API requests require an access token. (Contact WorkCompass to receive one.)

The API expects the access token to be included in the header of all requests
like so:

`Authorization: Token token=abcd1234`

<aside class="notice">
You should replace <code>abcd1234</code> with your organisation's API access
token.
</aside>

# URL

> An example of using the API URL with all necessary headers

```shell
curl -H "Authorization: Token token=abcd1234" \
     -H "Accept: application/vnd.api+json; version=2" \
     -H "Content-Type: application/vnd.api+json" \
     https://example.cognitohrm.com/api/
```

```ruby
require 'net/http'
require 'uri'

uri = URI.parse("https://example.cognitohrm.com/api/")
request = Net::HTTP::Get.new(uri)
request.content_type = "application/vnd.api+json"
request["Authorization"] = "Token token=abcd1234"
request["Accept"] = "application/vnd.api+json; version=2"

req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

# response.code
# response.body
```

You can access the WorkCompass API on the same subdomain that you access the
WorkCompass web app on. For example, if you you access the web app on
`https://example.cognitohrm.com` then you will access the API at
`https://example.cognitohrm.com/api/`.

<aside class="notice">
You should replace <code>example</code> with your subdomain.
</aside>

<aside class="notice">
All communication with WorkCompass is via HTTPS.
</aside>


# People

People records can be created, updated or deleted via the API. All data should
be sent to the API in the people object format presented below (with the
exception of archiving people records which does not require a JSON payload).

## Person Object

> An example of a single person record in JSON API format

```json
{
   "data" : {
      "type" : "people",
      "id" : "42AUQ",
      "attributes" : {
         "name" : "Morty Smith",
         "email" : "morty@example.com",
         "authorisation" : "employee",
         "division" : "House",
         "function" : "Teenager",
         "location" : "Anywhere/Anytime",
         "job-title" : "Sidekick",
         "job-description" : "Reluctantly follow Rick"
      },
      "relationships" : {
         "manager" : {
            "data" : {
               "type" : "people",
               "id" : "17BCC"
            }
         }
      }
   }
}
```

> An example of multiple people in JSON API format

```json
{
  "data" : [
    {
      "type" : "people",
      "id" : "42AUQ",
      "attributes" : {
         "name" : "Morty Smith",
         "email" : "morty@example.com",
         "authorisation" : "employee",
         "division" : "House",
         "function" : "Teenager",
         "location" : "Anywhere/Anytime",
         "job-title" : "Sidekick",
         "job-description" : "Reluctantly follow Rick"
      },
      "relationships" : {
        "manager" : {
          "data" : {
            "type" : "people",
            "id" : "17BCC"
          }
        }
      }
    },
    {
      "type" : "people",
      "id" : "29BVD",
      "attributes" : {
        "email" : "rick@example.com",
        "location" : "Anywhere/Anytime",
        "authorisation" : "manager",
        "division" : "Garage",
        "function" : "Scientist",
        "name" : "Rick Sanchez",
        "job-title" : "Mad Scientist",
        "job-description" : "Doing mad science"
      }
    }
  ]
}
```

The expected format is a JSON API object with a `data` key. The value of the
`data` key can either be a single person object or an array of person objects
(see sidebar).

A manager can be specified by including a `relationships.manager` object with
the appropriate unique id (e.g. employee number).

Each person object has the following attributes:

Attribute | Description | Required |
--------- | ----------- | -------- |
type | must be set to `people` | yes
id | unique id for the person at your organisation (e.g. employee number) | yes
attributes.name | the person's full name | except for delete
attributes.email | email address of the person | except for delete
attributes.authorisation | the authorisation level of the person in WorkCompass. Can be one of <ul><li>`employee`</li><li>`manager`</li><li>`divisional_admin`</li><li>`admin`</li></ul> | except for delete
attributes.division | Person's division or work group in your organisation |
attributes.location | Person's physical location |
attributes.function | Person's job function |
attributes.job-title | Person's job title |
attributes.job-description | Longer description of person's job |
relationships.manager.data.type | must be set to `people` | if specifying relationship
relationships.manager.data.id | Unique id for this person's manager (e.g manager's employee number) | if specifying relationship

## Creating People

### Creating a single person record

> Example of creating a single person record

```shell
curl -H "Authorization: Token token=abcd1234" \
     -H "Accept: application/vnd.api+json; version=2" \
     -H "Content-Type: application/vnd.api+json" \
     -X POST \
     -d '{ "data": { "type": "people", "id": "42AUQ", "attributes": { "name": "Morty Smith", "email": "morty@example.com", "authorisation": "employee" } } }' \
     https://example.cognitohrm.com/api/people/
```

```ruby
require 'net/http'
require 'uri'
require 'json'

uri = URI.parse("https://example.cognitohrm.com/api/people/")
request = Net::HTTP::Post.new(uri)
request.content_type = "application/vnd.api+json"
request["Authorization"] = "Token token=abcd1234"
request["Accept"] = "application/vnd.api+json; version=2"
request.body = JSON.dump({
  "data" => {
    "type" => "people",
    "id" => "42AUQ",
    "attributes" => {
      "name" => "Morty Smith",
      "email" => "morty@example.com",
      "authorisation" => "employee"
    }
  }
})

req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

# response.code
# response.body
```


#### HTTP Request

`POST /api/people`

### Creating multiple people in a batch request

> Example of creating a multiple people in one request

```shell
curl -H "Authorization: Token token=abcd1234" \
     -H "Accept: application/vnd.api+json; version=2" \
     -H "Content-Type: application/vnd.api+json" \
     -X POST \
     -d '{ "data": [ { "type": "people", "id": "42AUQ", "attributes": { "name": "Morty Smith", "email": "morty@example.com", "authorisation": "employee" } }, { "type": "people", "id": "17BCC", "attributes": { "name": "Rick Sanchez", "email": "rick@example.com", "authorisation": "manager" } } ] }' \
     https://example.cognitohrm.com/api/people/
```

```ruby
require 'net/http'
require 'uri'
require 'json'

uri = URI.parse("https://example.cognitohrm.com/api/people/")
request = Net::HTTP::Post.new(uri)
request.content_type = "application/vnd.api+json"
request["Authorization"] = "Token token=abcd1234"
request["Accept"] = "application/vnd.api+json; version=2"
request.body = JSON.dump({
  "data" => [
    {
      "type" => "people",
      "id" => "42AUQ",
      "attributes" => {
        "name" => "Morty Smith",
        "email" => "morty@example.com",
        "authorisation" => "employee"
      }
    },
    {
      "type" => "people",
      "id" => "17BCC",
      "attributes" => {
        "name" => "Rick Sanchez",
        "email" => "rick@example.com",
        "authorisation" => "manager"
      }
    }
  ]
})

req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

# response.code
# response.body
```

Note that if there is an error creating any records, the entire batch operation
will fail. Any errors encountered will be returned as an error object (see the
[errors section](#errors) below).

#### HTTP Request

`POST /api/people`


## Updating People

Any attributes sent in an update request will be modified on the person record
if different from what is already there. Any attributes not supplied will not be
modified (so there is no danger in sending complete person records to the API,
it will only change what is necessary).

If you would like to delete an attribute for a person (e.g. remove their job
title) you can set it to `null` in the JSON object. If you would like to remove
a person's manager from the person's record, you can set the
`relationships.manager.data` attribute to `null`.

The required fields (see table in [person object section](#people)) can only be
modified, never deleted.

If an account is active on WorkCompass (i.e. has signed in and used the web app
in the past), changing their email address will result in them getting an email
to confirm their new address.

### Updating a single person record

> Example of updating a single person record

```shell
curl -H "Authorization: Token token=abcd1234" \
     -H "Accept: application/vnd.api+json; version=2" \
     -H "Content-Type: application/vnd.api+json" \
     -X PUT \
     -d '{ "data": { "type": "people", "id": "42AUQ", "attributes": { "job-title": "Sidekick" } } }' \
     https://example.cognitohrm.com/api/people/42AUQ
```

```ruby
require 'net/http'
require 'uri'
require 'json'

uri = URI.parse("https://example.cognitohrm.com/api/people/42AUQ")
request = Net::HTTP::Put.new(uri)
request.content_type = "application/vnd.api+json"
request["Authorization"] = "Token token=abcd1234"
request["Accept"] = "application/vnd.api+json; version=2"
request.body = JSON.dump({
  "data" => {
    "type" => "people",
    "id" => "42AUQ",
    "attributes" => {
      "job-title" => "Sidekick"
    }
  }
})

req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

# response.code
# response.body
```

A person's `authorisation` can not be changed to `employee` if they currently
have people reporting to them in WorkCompass. You will have to move the
manager's reports to another manager before updating the authorisation (or use a
a batch operation below to move the reports and update the old manager's
authorisation in one request).

#### HTTP Request

`PUT /api/people/<PERSON_ID>`

### Updating multiple people in a batch request

> Example of updating a multiple people in one request

```shell
curl -H "Authorization: Token token=abcd1234" \
     -H "Accept: application/vnd.api+json; version=2" \
     -H "Content-Type: application/vnd.api+json" \
     -X PUT \
     -d '{ "data": [ { "type": "people", "id": "42AUQ", "attributes": { "authorisation": "admin" } }, { "type": "people", "id": "17BCC", "attributes": { "authorisation": "employee", "job-title": null } } ] }' \
     https://example.cognitohrm.com/api/people/
```

```ruby
require 'net/http'
require 'uri'
require 'json'

uri = URI.parse("https://example.cognitohrm.com/api/people/")
request = Net::HTTP::Put.new(uri)
request.content_type = "application/vnd.api+json"
request["Authorization"] = "Token token=abcd1234"
request["Accept"] = "application/vnd.api+json; version=2"
request.body = JSON.dump({
  "data" => [
    {
      "type" => "people",
      "id" => "42AUQ",
      "attributes" => {
        "authorisation" => "admin"
      }
    },
    {
      "type" => "people",
      "id" => "17BCC",
      "attributes" => {
        "authorisation" => "employee",
        "job-title" => nil
      }
    }
  ]
})

req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

# response.code
# response.body
```

Note that if there is an error updating any records, the entire batch operation
will fail. Any errors encountered will be returned as an error object (see the
[errors section](#errors) below).


#### HTTP Request

`PUT /api/people`


## Archiving People

Archiving people does not require you to send a person object, the
person record will be looked up via the unique ids in the URL.

There is currently no way to "un-archive" a person via the API. A HR admin at
your organisation will have to use the web app to restore a person's account.

### Archiving a single person record

> Example of archiving a single person record

```shell
curl -H "Authorization: Token token=abcd1234" \
     -H "Accept: application/vnd.api+json; version=2" \
     -H "Content-Type: application/vnd.api+json" \
     -X DELETE \
     https://example.cognitohrm.com/api/people/42AUQ
```

```ruby
require 'net/http'
require 'uri'

uri = URI.parse("https://example.cognitohrm.com/api/people/42AUQ")
request = Net::HTTP::Delete.new(uri)
request.content_type = "application/vnd.api+json"
request["Authorization"] = "Token token=abcd1234"
request["Accept"] = "application/vnd.api+json; version=2"

req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

# response.code
# response.body
```


#### HTTP Request

`DELETE /api/people/<PERSON_ID>`

### Archiving multiple people in a batch request

> Example of archiving multiple people in one request

```shell
curl -H "Authorization: Token token=abcd1234" \
     -H "Accept: application/vnd.api+json; version=2" \
     -H "Content-Type: application/vnd.api+json" \
     -X DELETE \
     https://example.cognitohrm.com/api/people/?ids=42AUQ,17BCC
```

```ruby
require 'net/http'
require 'uri'

uri = URI.parse("https://example.cognitohrm.com/api/people/?ids=42AUQ,17BCC")
request = Net::HTTP::Delete.new(uri)
request.content_type = "application/vnd.api+json"
request["Authorization"] = "Token token=abcd1234"
request["Accept"] = "application/vnd.api+json; version=2"

req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

# response.code
# response.body
```

The unique ids for the people to be deleted should be passed as a list of unique
ids with the `ids` parameter to the URL.

Note that if there is an error archiving any records, the entire batch operation
will fail. Any errors encountered will be returned as an error object (see the
[errors section](#errors) below).

#### HTTP Request

`DELETE /api/people`
