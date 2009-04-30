/*
	Copyright (c) 2008, Adobe Systems Incorporated
	All rights reserved.

	Redistribution and use in source and binary forms, with or without 
	modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, 
    	this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, 
    	this list of conditions and the following disclaimer in the 
    	documentation and/or other materials provided with the distribution.
    * Neither the name of Adobe Systems Incorporated nor the names of its 
    	contributors may be used to endorse or promote products derived from 
    	this software without specific prior written permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
	ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
	LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
	POSSIBILITY OF SUCH DAMAGE.
*/

import com.adobe.webapis.flickr.FlickrService;
import com.adobe.webapis.flickr.User;
import com.adobe.webapis.flickr.authorization.AuthorizationView;
import com.adobe.webapis.flickr.authorization.events.AuthorizationEvent;
import com.adobe.webapis.flickr.events.FlickrResultEvent;


/************ Panel State Constants ****************/

//initial state
private static const START_STATE:String = "";

//settings error state - if required settings are not set
private static const SETTINGS_ERROR_STATE:String = "settingsErrorState";

//progress state - why waiting for response for server
private static const AUTHORIZATION_STATE:String = "authorizationState";

//state view to launch flickr in browser for authorization
private static const URL_AUTHORIZATION_STATE:String = "urlAuthorizationState";

//state view to start the process to get the authorization token
private static const GET_TOKEN_STATE:String = "gettokenState";

//authorization has been completed
private static const AUTHORIZATION_COMPLETE_STATE:String = "authorizationCompleteState";

//state view in case any errors occur
private static const ERROR_STATE:String = "errorState";

/******** private vars ************/

private var _settings:FlickrAuthorizationSettings;

//flickr api instance
private var flickr:FlickrService;

//authorization url for user authorization
private var authorizationURL:String;

//frob returned from flickr
private var frob:String;

public var flickrAPIKey:String;
public var flickrAPISecret:String;


/************* public vars / getters / setters *************/

/*
//application settings
public function set settings(value:FlickrAuthorizationSettings):void
{
	_settings = value;
	
	//make sure the settings we need to authorize have been set
	if(_settings.flickrAPIKey == null || _settings.flickrAPIKey.length == 0 ||
		_settings.flickrAPISecret == null || _settings.flickrAPISecret.length == 0)
	{
		//if not, then go to the error state view
		currentState = SETTINGS_ERROR_STATE;
	}
}
*/


/************* Event Handlers ***************/

//when cancel button is clicked
private function onCancelClick():void
{
	closeWindow();
}

//event handler called to start authorization process
private function onAuthorizationStartClick():void
{
		
	//make sure the settings we need to authorize have been set
	if(flickrAPIKey == null || flickrAPIKey.length == 0 ||
		flickrAPISecret == null || flickrAPISecret.length == 0)
	{
		//if not, then go to the error state view
		currentState = SETTINGS_ERROR_STATE;
		return;
	}
	
	//change state
	currentState = AUTHORIZATION_STATE;
	
	//initialize flickr instance
	flickr = new FlickrService(flickrAPIKey);
	flickr.secret = flickrAPISecret;
	
	//register for events
	flickr.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
	flickr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
	flickr.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);					
	flickr.addEventListener(FlickrResultEvent.AUTH_GET_FROB, onGetFrob);
	
	//retrieve frob from flickr. This goes to the flickr server, and is async
	flickr.auth.getFrob();				
	
	//update progress bar
	pBar.label = "Retrieving Frob from Flickr";
}

//handles any IOErrors while communicating with flickr
private function onIOError(e:ErrorEvent):void
{
	//send an error, with info on error
	setError(e.text);
}

//handles any security errors that occur while communicating with flickr
private function onSecurityError(e:SecurityErrorEvent):void
{
	//send an error, with info on error
	setError(e.text);
}

//handles any errors that occur in response to http status responses
//from server
private function onHTTPStatus(e:HTTPStatusEvent):void
{
	//send an error, with info on error
	setError("HTTP Status : " + e.status);
}

//called when the frob is returned from flickr
private function onGetFrob(e:FlickrResultEvent):void
{
	//save the frob in class instance
	frob = e.data.frob;
	
	//create the authorization url using the frob
	authorizationURL = flickr.getLoginURL(frob, "write");
	
	//switch to the url auth state to prompt the user to launch flickr
	//in their browser
	currentState = URL_AUTHORIZATION_STATE;
}

//called when the user clicks the button to launch flickr in the browser
//to authorize the app
private function onLaunchFlickrClick():void
{
	//open the url in the systems default browser
	navigateToURL(new URLRequest(authorizationURL));
	
	//switch to the state to retrieve tge authorization token
	currentState = GET_TOKEN_STATE;
}			

//called when the user clicks the button to retrieve the authorization token
//from flickr
private function onGetTokenClick():void
{
	//change state to show progress bar
	currentState = AUTHORIZATION_STATE;
	
	//set progress bar label
	pBar.label = "Retrieving Application Token from Flickr";
	
	//register for event when token is returned
	flickr.addEventListener(FlickrResultEvent.AUTH_GET_TOKEN, onGetToken);
	
	//request token from flickr api. This goes to the flickr server and is
	//async
	flickr.auth.getToken(frob);
}


//called when the response is received from flickr after request authorization
//token
private function onGetToken(e:FlickrResultEvent):void
{
	//check and see if token was returned
	if(e.data.auth == null)
	{
		//if not, there was an error, or it was rejected
		//send error with info
		setError(e.data.error.errorMessage);
		return;
	}
	
	//we got the token. finally!!!
	//save token in settings
	//_settings.authToken = e.data.auth.token;
	
	//get the flickr account's user name and save it in settings
	//_settings.accountName = e.data.auth.user.username;
	
	//send a SettingsEvent to indicate that settings have been updated
	//todovar sEvent:SettingsEvent = new SettingsEvent(SettingsEvent.SETTINGS_CHANGED);
	//todo	sEvent.settings = _settings;
		
	//tododispatchEvent(sEvent);
	
	var out:AuthorizationEvent = new AuthorizationEvent(AuthorizationEvent.AUTHORIZATION_COMPLETE);
		out.user = User(e.data.auth.user);
		out.authToken = e.data.auth.token;
		
	dispatchEvent(out);
	
	//change state to authorization complete
	currentState = AUTHORIZATION_COMPLETE_STATE;
}

//called when the user clicks the open settings button from the auth panel
private function onOpenSettingsClick():void
{
	//dispatch an event requesting that settings be opened
	//todo var e:AuthorizationEvent = new AuthorizationEvent(AuthorizationEvent.ON_LAUNCH_SETTINGS);
	//tododispatchEvent(e);
	
	//close window
	closeWindow();
}

//close button handler
private function onCloseClick():void
{
	closeWindow();
}

//handler for try again button, which is present when authorization fails
private function onTryAgainClick():void
{	
	//reinitialize state of panel
	frob = null;
	authorizationURL = null;
	
	//return to start state;
	currentState = START_STATE;
}


/************ General functions **************/

//broadcast close event
private function closeWindow():void
{
	var e:Event = new Event(Event.CLOSE);
	dispatchEvent(e);
}

//sends an error event with information about the error
private function setError(msg:String):void
{
	//Log.getLogger(AIRSnapshot.LOG_NAME).error("AuthorizationView : " + msg);
	currentState = ERROR_STATE;
	errorField.text = "Error : " + msg;
}