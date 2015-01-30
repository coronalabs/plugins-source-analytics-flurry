# analytics.*

> --------------------- ------------------------------------------------------------------------------------------
> __Type__              [CoronaProvider][api.type.CoronaProvider]
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          analytics, Flurry
> __Availability__      Starter, Basic, Pro, Enterprise
> __Platforms__			Android, iOS
> --------------------- ------------------------------------------------------------------------------------------

## Overview

The Flurry plugin lets you log interesting events in your application via the [analytics][api.library.analytics] library.

## Registration

To use Flurry analytics, please [register]((http://www.flurry.com)) for an account.

## Syntax

	local analytics = require( "analytics" )

## Functions

#### [analytics.init()][plugin.flurry.init]

#### [analytics.logEvent()][plugin.flurry.logEvent]

## Project Settings

To use this plugin, add two entries into the `plugins` table of `build.settings`. When added, the build server will integrate the plugin during the build phase.

``````lua
settings =
{
	plugins =
	{
		["CoronaProvider.analytics.flurry"] =
		{
			publisherId = "com.coronalabs"
		},
		["plugin.google.play.services"] =
		{
			publisherId = "com.coronalabs"
		},
	},
}
``````