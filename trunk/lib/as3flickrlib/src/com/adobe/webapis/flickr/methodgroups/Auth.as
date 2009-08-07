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

package com.adobe.webapis.flickr.methodgroups {
	
	import com.adobe.webapis.flickr.events.FlickrResultEvent;
	import com.adobe.webapis.flickr.*;
	import flash.events.Event;
	import flash.net.URLLoader;
	
		/**
		 * Broadcast as a result of the checkToken method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, contains an "auth" AuthResult instance
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #checkToken
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="authCheckToken", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getFrob method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, contains a "frob" string (the frob value to be 
		 *				used for authentication)
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getFrob
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="authGetFrob", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
		
		/**
		 * Broadcast as a result of the getToken method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, contains an "auth" AuthResult instance
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getToken
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="authGetToken", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]	
	
	/**
	 * Contains the methods for the Auth method group in the Flickr API.
	 * 
	 * Even though the events are listed here, they're really broadcast
	 * from the FlickrService instance itself to make using the service
	 * easier.
	 */
	public class Auth {
			 
		/** 
		 * A reference to the FlickrService that contains the api key
		 * and logic for processing API calls/responses
		 */
		private var _service:FlickrService;
	
		/**
		 * Construct a new Test "method group" class
		 *
		 * @param service The FlickrService this method group
		 *		is associated with.
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function Auth( service:FlickrService ) {
			_service = service;
		}
		
		/**
		 * Returns the credentials attached to an authentication token.
		 *
		 * @param token The authentication token to check
		 * @see http://www.flickr.com/services/api/flickr.auth.checkToken.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function checkToken( token:String ):void {
			// Let the Helper do the work to invoke the method
			MethodGroupHelper.invokeMethod( _service, checkToken_result, 
								   "flickr.auth.checkToken", 
								   true,
								   new NameValuePair( "auth_token", token ) );
		}
		
		/**
		 * Capture the result of the checkToken call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function checkToken_result( event:Event ):void {
			// Create an AUTH_CHECK_TOKEN event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.AUTH_CHECK_TOKEN );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "auth",
												  MethodGroupHelper.parseAuthResult );
		}
		
		/**
		 * Returns a frob to be used during authentication.
		 *
		 * @see http://www.flickr.com/services/api/flickr.auth.getFrob.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getFrob():void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getFrob_result, "flickr.auth.getFrob", true );
		}
		
		/**
		 * Capture the result of the getFrob call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getFrob_result( event:Event ):void {
			// Create an AUTH_GET_FROB event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.AUTH_GET_FROB );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "frob",
												  MethodGroupHelper.parseFrob );
		}
		
		/**
		 * Returns the auth token for the given frob, if one has been attached.
		 *
		 * @param frob The frob to get the token for
		 *
		 * @see http://www.flickr.com/services/api/flickr.auth.getToken.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getToken( frob:String ):void {
			// Let the Helper do the work to invoke the method
			MethodGroupHelper.invokeMethod( _service, getToken_result, 
									"flickr.auth.getToken",
									true,
									new NameValuePair( "frob", frob ) );
		}
		
		/**
		 * Capture the result of the getToken call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getToken_result( event:Event ):void {
			// Create an AUTH_GET_TOKEN event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.AUTH_GET_TOKEN );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "auth",
												  MethodGroupHelper.parseAuthResult );
			
		}
		
	}	
	
}