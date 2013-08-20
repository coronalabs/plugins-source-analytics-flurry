# analytics.init()

> --------------------- ------------------------------------------------------------------------------------------
> __Type__              [Function][api.type.Function]
> __Library__           [analytics.*][api.library.analytics]
> __Return value__      None
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          
> __Sample code__       */CoronaSDK/SampleCode/Analytics/FlurrySample*
> __See also__          [analytics.logEvent()][api.library.analytics.logEvent]
> --------------------- ------------------------------------------------------------------------------------------


## Overview

Initializes the analytics library.

## Syntax

	analytics.init( apiKey )

##### apiKey ~^(required)^~
_[String][api.type.String]._ The API key provided by the analytics service provider you are using. See 'API Keys' below.


## API Keys

Each section below describes how to obtain an API key for the respective service:

### Flurry

Sign up for an account on [Flurry](http://www.flurry.com). Once you have logged in to the Flurry dashboard, go to Manage Applications. Click "Create a new app". Choose iPhone, iPad, or Android as appropriate. This will create an "Application key" which you must enter in the code.

Use [analytics.logEvent(string)][api.library.analytics.logEvent] to log events. In your Flurry account, choose "View analytics" to see the data created by your app.

Note that it takes some time for the analytics data to appear in the Flurry statistics, it does not appear immediately.

## Gotchas

#### Android

On Android, you must set the Internet permission in your "build.settings" file in order to record and send analytics data.

You may optionally set the following location permissions in your "build.settings" file if you want Flurry to record the end-user's current location, such as latitude and longitude. If you do not set these location permissions, then Flurry can only record the country the app was used in based on the device's locale and region settings. Note that if you add these location permissions, then you set up your app to not require location services such as GPS as shown below or else devices that do not support location services (such as the 1st generation Kindle Fire) will be unable to by your app.

``````lua
settings =
{
   android =
   {
      usesPermissions =
      {
         -- This permission is required in order for analytics to be sent to Flurry's servers.
         "android.permission.INTERNET",

         -- These permissions are optional.
         -- If set, then Flurry will also record current location via GPS and/or WiFi.
         -- If not set, then Flurry can only record which country the app was used in.
         "android.permission.ACCESS_FINE_LOCATION",    -- Fetches location via GPS.
         "android.permission.ACCESS_COARSE_LOCATION",  -- Fetches location via WiFi or cellular service.
      },
      usesFeatures =
      {
         -- If you set permissions "ACCESS_FINE_LOCATION" and "ACCESS_COARSE_LOCATION" above,
         -- then you should set up your app to not require location services as follows.
         -- Otherwise, devices that do not have location sevices (such as a GPS) will be unable
         -- to purchase this app in the app store.
         { name = "android.hardware.location", required = false },
         { name = "android.hardware.location.gps", required = false },
         { name = "android.hardware.location.network", required = false },
      },
   },
}
``````

## Examples

This example assumes you are using Flurry as your analytics provider. You must have an application key provided by Flurry to use the service. This version of the library does not support location-enabled Flurry events.

The following code demonstrates basic usage of the analytics library.

``````lua
local analytics = require "analytics"

-- initialize with proper API key corresponding to your application
analytics.init( "YOUR_API_KEY" )

-- log events
analytics.logEvent( "Event ID" )
``````
