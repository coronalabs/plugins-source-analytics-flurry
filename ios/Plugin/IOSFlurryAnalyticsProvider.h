// ----------------------------------------------------------------------------
// 
// IOSFlurryAnalyticsProvider.h
// Copyright (c) 2012 Corona Labs Inc. All rights reserved.
//
// ----------------------------------------------------------------------------

#ifndef _IOSFlurryAnalyticsProvider_H__
#define _IOSFlurryAnalyticsProvider_H__

#include "CoronaLua.h"

// ----------------------------------------------------------------------------

CORONA_EXPORT int luaopen_CoronaProvider_analytics_flurry( lua_State *L );

// ----------------------------------------------------------------------------

@class NSString;
@protocol CoronaRuntime;

namespace Corona
{

// ----------------------------------------------------------------------------

class IOSFlurryAnalyticsProvider
{
	public:
		typedef IOSFlurryAnalyticsProvider Self;

	public:
		static const char kName[];

	public:
		static int Open( lua_State *L );

	protected:
		static int Finalizer( lua_State *L );

	protected:
		static Self *GetSelf( lua_State *L );
		static int Init( lua_State *L );
		static int LogEvent( lua_State *L );

	public:
		IOSFlurryAnalyticsProvider( id<CoronaRuntime> runtime );
		virtual ~IOSFlurryAnalyticsProvider();

	public:
		bool Init( lua_State *L, const char *appId );
		void LogEvent( lua_State *L, const char *eventId, int paramsIndex );

	protected:
		id<CoronaRuntime> fRuntime;
		NSString *fAppId;
};

// ----------------------------------------------------------------------------

} // namespace Corona

// ----------------------------------------------------------------------------

#endif // _IOSFlurryAnalyticsProvider_H__
