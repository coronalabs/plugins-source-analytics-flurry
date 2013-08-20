// ----------------------------------------------------------------------------
// 
// LuaLoader.java
// Copyright (c) 2012 Corona Labs Inc. All rights reserved.
//
// ----------------------------------------------------------------------------

package CoronaProvider.analytics.flurry;

import android.app.Activity;
import android.util.Log;
import com.naef.jnlua.LuaState;
import com.naef.jnlua.LuaType;
import com.naef.jnlua.JavaFunction;
import com.naef.jnlua.NamedJavaFunction;
import com.ansca.corona.CoronaActivity;
import com.ansca.corona.CoronaEnvironment;
import com.ansca.corona.CoronaRuntime;
import com.ansca.corona.CoronaRuntimeListener;
import com.flurry.android.FlurryAgent;
import java.util.HashMap;

public class LuaLoader implements JavaFunction, CoronaRuntimeListener {

	private String fApplicationId = null;
	private boolean fSessionStarted = false;

	/**
	 * Creates a new object for displaying banner ads on the CoronaActivity
	 */
	public LuaLoader() {
		initialize();
	}

	protected void initialize() {
		// Initialize member variables.
		fApplicationId = null;
		fSessionStarted = false;
	}

	/**
	 * Warning! This method is not called on the main UI thread.
	 */
	@Override
	public int invoke(LuaState L) {
		initialize();

		NamedJavaFunction[] luaFunctions = new NamedJavaFunction[] {
			new InitWrapper(),
			new LogEventWrapper(),
		};

		String libName = L.toString( 1 );
		L.register(libName, luaFunctions);

		return 1;
	}

	// CoronaRuntimeListener
	@Override
	public void onLoaded(CoronaRuntime runtime) {
	}

	// CoronaRuntimeListener
	@Override
	public void onStarted(CoronaRuntime runtime) {
	}

	// CoronaRuntimeListener
	@Override
	public void onSuspended(CoronaRuntime runtime) {
		if ( null != fApplicationId ) {
			fSessionStarted = false;
			FlurryAgent.onEndSession( CoronaEnvironment.getCoronaActivity() );
		}
	}

	// CoronaRuntimeListener
	@Override
	public void onResumed(CoronaRuntime runtime) {
		if ( null != fApplicationId ) {
			fSessionStarted = true;
			FlurryAgent.onStartSession( CoronaEnvironment.getCoronaActivity(), fApplicationId );
		}
	}

	// CoronaRuntimeListener
	@Override
	public void onExiting(CoronaRuntime runtime) {
	}

	// analytics.init( providerName, appId )
	public int init(LuaState L) {
		boolean success = false;

		// Fetch the Corona activity, if available.
		CoronaActivity activity = CoronaEnvironment.getCoronaActivity();

		// Start the Flurry session if an App ID was given and the activity window is still available.
		if ( !fSessionStarted && (null == fApplicationId) && (activity != null) ) {
			activity.enforceCallingOrSelfPermission(android.Manifest.permission.INTERNET, null);
			String appId = L.toString( 2 );
			if ( null != appId ) {
				fApplicationId = new String( appId );
				fSessionStarted = true;
				FlurryAgent.onStartSession(activity, appId);
				success = true;
			}
		}

		// Returns true if successfully started a Flurry session.
		L.pushBoolean( success );
		return 1;
	}

	// Convert to string, but avoid implicit Lua conversion which confuses lua_next
	static String ToString( LuaState L, int index )
	{
		String result = null;

		LuaType t = L.type( -2 );
		switch ( t )
		{
			case NUMBER:
				result = String.valueOf( L.toNumber( index ) );
				break;
			default:
				result = L.toString( index );
				break;
		}

		return result;
	}


	// analytics.logEvent( eventId [, params] )
	public int logEvent(LuaState L) {
		if ( fSessionStarted ) {
			final String eventId = L.checkString( 1 );

			if ( null != eventId )
			{
				int paramsIndex = 2;

				final int kMaxParams = 10;
				final HashMap< String, String > params =
					( L.isTable( paramsIndex ) ? new HashMap< String, String >( kMaxParams ) : null );

				if ( null != params ) {

					// Convert Lua table to Map
					L.pushNil();
					for ( int i = 0; ( i < kMaxParams ) && L.next( paramsIndex ); i++ ) {
						String key = ToString( L, -2 );
						String value = ToString( L, -1 );

						if ( null != key && null != value )
						{
							params.put( key, value );
						}

						L.pop( 1 );
					}

					FlurryAgent.onEvent( eventId, params );
				}
				else {
					FlurryAgent.onEvent( eventId );
				}
			}

		}

		return 0;
	}

	private class InitWrapper implements NamedJavaFunction {
		@Override
		public String getName() {
			return "init";
		}
		
		/**
		 * Warning! This method is not called on the main UI thread.
		 */
		@Override
		public int invoke(LuaState L) {
			return init(L);
		}
	}

	private class LogEventWrapper implements NamedJavaFunction {
		@Override
		public String getName() {
			return "logEvent";
		}
		
		/**
		 * Warning! This method is not called on the main UI thread.
		 */
		@Override
		public int invoke(LuaState L) {
			return logEvent(L);
		}
	}
}