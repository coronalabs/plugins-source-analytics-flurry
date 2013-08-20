# analytics.logEvent()

> --------------------- ------------------------------------------------------------------------------------------
> __Type__              [Function][api.type.Function]
> __Library__           [analytics.*][api.library.analytics]
> __Return value__      None
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          
> __Sample code__       */CoronaSDK/SampleCode/Analytics/FlurrySample*
> __See also__          [analytics.init()][api.library.analytics.init]
> --------------------- ------------------------------------------------------------------------------------------


## Overview

Reports a custom event defined by a string value.

Regardless of whether you call logEvent(), the analytic provider will send basic analytics data like number of users, session length, etc, that you can track/graph.

## Syntax

	analytics.logEvent( eventID )
	analytics.logEvent( eventID, params )

##### eventID ~^(required)^~
_[String][api.type.String]._ Contains the event information to be logged with the analytics service.

##### params ~^(optional)^~
_[Table][api.type.Table]._ A table of key/value pairs.


## Examples

``````lua
local analytics = require "analytics"

analytics.init( "YOUR_API_KEY" )

function newGame(event)
  -- Log event
  analytics.logEvent("New Game")

  -- New game code follows...
end
 
newGameBtn:addEventListener( "touch", newGame )
``````
