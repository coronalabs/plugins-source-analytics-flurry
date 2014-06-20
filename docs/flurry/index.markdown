# analytics.*

> --------------------- ------------------------------------------------------------------------------------------
> __Type__              [CoronaLibrary][api.type.CoronaLibrary]
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          analytics
> __Sample code__       */CoronaSDK/SampleCode/Analytics/FlurrySample*
> __See also__
> __Availability__      Starter, Pro, Enterprise          
> --------------------- ------------------------------------------------------------------------------------------

## Overview

The Corona analytics library lets you easily log interesting events in your application.

## Platforms

The following platforms are supported:

* Android
* iOS
* Amazon
* Nook

## Functions

#### [analytics.init()][plugin.flurry.init]

#### [analytics.logEvent()][plugin.flurry.logEvent]

## build.settings

The following build.settings section is required to for Google Play game services

``````lua
settings =
{
	plugins =
	{
		-- key is the name passed to Lua's 'require()'
		["CoronaProvider.analytics.flurry"] =
		{
			-- required
			publisherId = "com.coronalabs",
		},
	},
}
``````