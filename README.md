# Campaign Validator

A service to detect discrepancies between job campaigns and ads.

## Getting started

### Install dependecies and set up databases

```$ script/bootstrap ```

# Configuration

## Required environment variables

* `AD_SEVICE_URL`: The URL of the Ad Service

# Testing locally

To run the service, simply run ```rails server```

To send a request:
```
curl -H "Content-Type: application/json" -X POST -d '{"campaigns":[{"id":1}]}' http://localhost:3000/campaigns/verify
```

# Features

The Campaign Validator can detect if there is a discretancy between
the local values for certain campaigns and their set values in the
AdService service.

## Detectable discrepancies

Things the service currently checks for:
* Mismatch in status values
  `paused` and `deleted` campaigns should have `disabled` statuses in the AdService, while `active` campaigns should be `enabled`
* Mismatch in the ad descriptions
* Campaigns that are missing from AdService altogether

In the future it might check for additional things, like multiple campaigns refering to the same AdService, etc.

## Request format

The service expects a JSON with a list of campaigns:
```
{
  "campaigns": [
    {
      "id": 1
    },
    {
      "id": 2
    }
  ]
}
```

## Response format
The services enriches the request JSON with extra data about
discrepancies.
```
{
  "campaigns": [
    {
      "id": 1,
      "missing": true
    },
    {
      "id": 2,
      "missing": false,
      "status": {
        "local_value": "active",
        "ad_service_value": "enabled",
        "consistent": true
      },
      "ad_description": {
        "local_value": "Description",
        "ad_service_value": "Jibberjabber",
        "consistent": false
      }
    }
  ]
}
```
The service will respond with a 500 HTTP code if it fails to find any of the requested campaigns in the database.

