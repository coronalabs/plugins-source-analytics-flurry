// ----------------------------------------------------------------------------
// 
// IOSFlurryAnalyticsProvider.cpp
// Copyright (c) 2012 Corona Labs Inc. All rights reserved.
// 
// ----------------------------------------------------------------------------

#include "IOSFlurryAnalyticsProvider.h"

#include "CoronaAssert.h"
#include "CoronaEvent.h"
#include "CoronaLibrary.h"

#import <Foundation/Foundation.h>
#import "Flurry.h"
#import "CoronaRuntime.h"

// ----------------------------------------------------------------------------

CORONA_EXPORT
int luaopen_CoronaProvider_analytics_flurry( lua_State *L )
{
	return Corona::IOSFlurryAnalyticsProvider::Open( L );
}

// ----------------------------------------------------------------------------

namespace Corona
{

// ----------------------------------------------------------------------------

const char IOSFlurryAnalyticsProvider::kName[] = "CoronaProvider.analytics.flurry";
    
// TODO: Rename. Should correspond to kName above
static const char kProviderName[] = "flurry";
    
// TODO: Rename.
static const char kPublisherId[] = "com.coronalabs";

int
IOSFlurryAnalyticsProvider::Open( lua_State *L )
{
	void *platformContext = CoronaLuaGetContext( L ); // lua_touserdata( L, lua_upvalueindex( 1 ) );
	id<CoronaRuntime> runtime = (id<CoronaRuntime>)platformContext;

	const char *name = lua_tostring( L, 1 ); CORONA_ASSERT( 0 == strcmp( name, kName ) );
	int result = CoronaLibraryProviderNew( L, "analytics", name, kPublisherId );

	if ( result )
	{
		const luaL_Reg kFunctions[] =
		{
			{ "init", Self::Init },
			{ "logEvent", Self::LogEvent },

			{ NULL, NULL }
		};

		CoronaLuaInitializeGCMetatable( L, kName, Finalizer );

		// Use 'provider' in closure for kFunctions
		Self *provider = new Self( runtime );
		CoronaLuaPushUserdata( L, provider, kName );
		luaL_openlib( L, NULL, kFunctions, 1 );
	}

	return result;
}

int
IOSFlurryAnalyticsProvider::Finalizer( lua_State *L )
{
	Self *provider = (Self *)CoronaLuaToUserdata( L, 1 );
	delete provider;
	return 0;
}

IOSFlurryAnalyticsProvider *
IOSFlurryAnalyticsProvider::GetSelf( lua_State *L )
{
	return (Self *)CoronaLuaToUserdata( L, lua_upvalueindex( 1 ) );
}

// analytics.init( providerName, appId )
int
IOSFlurryAnalyticsProvider::Init( lua_State *L )
{
	Self *provider = GetSelf( L );

	const char *appId = lua_tostring( L, 2 );

	bool success = provider->Init( L, appId );
	lua_pushboolean( L, success );

	return 1;
}

// analytics.logEvent( eventId [, params] )
int
IOSFlurryAnalyticsProvider::LogEvent( lua_State *L )
{
	Self *provider = GetSelf( L );

	const char *eventId = luaL_checkstring( L, 1 );
	if ( eventId )
	{
		int paramsIndex = 2;

		provider->LogEvent( L, eventId, paramsIndex );
	}
	
	return 1;
}

// ----------------------------------------------------------------------------

IOSFlurryAnalyticsProvider::IOSFlurryAnalyticsProvider( id<CoronaRuntime> runtime )
:	fRuntime( runtime ),
	fAppId( nil )
{
}

IOSFlurryAnalyticsProvider::~IOSFlurryAnalyticsProvider()
{
	[fAppId release];
}

bool
IOSFlurryAnalyticsProvider::Init( lua_State *L, const char *appId )
{
	bool result = false;

	if ( appId )
	{
		fAppId = [[NSString alloc] initWithUTF8String:appId];
		[Flurry startSession:fAppId];
//		[FlurryAnalytics setDebugLogEnabled:YES];

		result = true;
	}

	return result;
}

// Convert to string, but avoid implicit Lua conversion which confuses lua_next
static NSString *
ToNSString( lua_State *L, int index )
{
	NSString *result = nil;

	int t = lua_type( L, -2 );
	switch ( t )
	{
		case LUA_TNUMBER:
			result = [NSString stringWithFormat:@"%g", lua_tonumber( L, index )];
			break;
		default:
			result = [NSString stringWithUTF8String:lua_tostring( L, index )];
			break;
	}

	return result;
}

void
IOSFlurryAnalyticsProvider::LogEvent( lua_State *L, const char *eventId, int paramsIndex )
{
	CORONA_ASSERT( eventId );

	if ( fAppId )
	{
		NSString *str = [NSString stringWithUTF8String:eventId];

		if ( lua_istable( L, paramsIndex ) )
		{
			const int kMaxParams = 10;
			NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:kMaxParams];

			// Iterate through table
			paramsIndex = CoronaLuaNormalize( L, paramsIndex );
			lua_pushnil( L );
			for ( int i = 0; ( i < kMaxParams ) && lua_next( L, paramsIndex ); i++ )
			{
				NSString *key = ToNSString( L, -2 );
				NSString *value = ToNSString( L, -1 );

				if ( key && value )
				{
					[params setValue:value forKey:key];
				}

				lua_pop( L, 1 );
			}


			[Flurry logEvent:str withParameters:params];
		}
		else
		{
			[Flurry logEvent:str];
		}
	}
}

// ----------------------------------------------------------------------------

} // namespace Corona

// ----------------------------------------------------------------------------
