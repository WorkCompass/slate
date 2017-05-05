# Errors codes

> Example of an error object

```json
{
  "errors": [
    {
        "source": { "pointer": "/data/PERSON_ID/email" },
        "title": "Email address is invalid",
        "detail": "Email address 'joe' is not a valid email address"
    },
    {
        "source": { "pointer": "/data/PERSON_ID" },
        "title": "Person not found",
        "detail": "The person with id PERSON_ID could not be found."
    }
  ]
}
```

The WorkCompass API uses the following error codes:

Error Code | Meaning
---------- | -------
400 | Bad Request -- There was a problem with your request. Please see the returned error messages.
401 | Unauthorized -- Your API key is incorrect.
404 | Not Found -- The specified resource could not be found.
500 | Internal Server Error -- We had a problem with our server. Try again later.
503 | Service Unavailable -- We're temporarily offline for maintenance. Please try again later.



A `400 Bad Request` response will include a JSON API error object in the format
shown on the right.
