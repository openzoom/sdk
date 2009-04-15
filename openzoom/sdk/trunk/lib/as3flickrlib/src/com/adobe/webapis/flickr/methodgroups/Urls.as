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
	 * Broadcast as a result of the getGroup method being called
	 *
	 * The event contains the following properties
	 *	success	- Boolean indicating if the call was successful or not
	 *	data - When success is true, a Group instance
	 *		   When success is false, contains an "error" FlickrError instance
	 *
	 * @see #getList
	 * @see com.adobe.service.flickr.FlickrError
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 8.5
	 * @tiptext
	 */
	[Event(name="urlsGetGroup", 
		 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
		 
	/**
	 * Broadcast as a result of the getUserPhotos method being called
	 *
	 * The event contains the following properties
	 *	success	- Boolean indicating if the call was successful or not
	 *	data - When success is true, a User instance
	 *		   When success is false, a FlickrError instnace
	 *
	 * @see #getUserPhotos
	 * @see com.adobe.service.flickr.FlickrError
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 8.5
	 * @tiptext
	 */
	[Event(name="urlsGetUserPhotos", 
		 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
		 
	/**
	 * Broadcast as a result of the getUserProfile method being called
	 *
	 * The event contains the following properties
	 *	success	- Boolean indicating if the call was successful or not
	 *	data - When success is true, a User instance
	 *		   When success is false, contains an "error" FlickrError instance
	 *
	 * @see #getUserProfile
	 * @see com.adobe.service.flickr.FlickrError
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 8.5
	 * @tiptext
	 */
	[Event(name="urlsGetUserProfile", 
		 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
		 
	/**
	 * Broadcast as a result of the lookupGroup method being called
	 *
	 * The event contains the following properties
	 *	success	- Boolean indicating if the call was successful or not
	 *	data - When success is true, a Group instnace
	 *		   When success is false, contains an "error" FlickrError instance
	 *
	 * @see #lookupGroup
	 * @see com.adobe.service.flickr.FlickrError
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 8.5
	 * @tiptext
	 */
	[Event(name="urlsLookupGroup", 
		 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
		 
	/**
	 * Broadcast as a result of the lookupUser method being called
	 *
	 * The event contains the following properties
	 *	success	- Boolean indicating if the call was successful or not
	 *	data - When success is true, a User
	 *		   When success is false, contains an "error" FlickrError instance
	 *
	 * @see #lookupUser
	 * @see com.adobe.service.flickr.FlickrError
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 8.5
	 * @tiptext
	 */
	[Event(name="urlsLookupUser", 
		 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
	
	/**
	 * Contains the methods for the Urls method group in the Flickr API.
	 * 
	 * Even though the events are listed here, they're really broadcast
	 * from the FlickrService instance itself to make using the service
	 * easier.
	 */
	public class Urls {
	
		/** 
		 * A reference to the FlickrService that contains the api key
		 * and logic for processing API calls/responses
		 */
		private var _service:FlickrService;
	
		/**
		 * Construct a new Notes "method group" class
		 *
		 * @param service The FlickrService this method group
		 *		is associated with.
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function Urls( service:FlickrService ) {
			_service = service;
		}
	
		/**
		 * Returns the url to a group's page.
		 *
		 * @param group_id The NSID of the group to fetch the url for.
		 * @see http://www.flickr.com/services/api/flickr.urls.getGroup.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getGroup( group_id:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getGroup_result, 
								   "flickr.urls.getGroup", 
								   false,
								   new NameValuePair( "group_id", group_id ) );
		}
		
		/**
		 * Capture the result of the getGroup call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getGroup_result( event:Event ):void {
			// Create a URLS_GET_GROUP event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.URLS_GET_GROUP );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "group",
												  MethodGroupHelper.parseGroup );
		}
		
		/**
		 * Returns the url to a user's photos.
		 *
		 * @param user_id (Optional) The NSID of the user to fetch the url for.
		 *			If omitted, the calling user is assumed.
		 * @see http://www.flickr.com/services/api/flickr.urls.getUserPhotos.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getUserPhotos( user_id:String = "" ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getUserPhotos_result, 
								   "flickr.urls.getUserPhotos", 
								   false,
								   new NameValuePair( "user_id", user_id ) );
		}
		
		/**
		 * Capture the result of the getUserPhotos call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getUserPhotos_result( event:Event ):void {
			// Create a URLS_GET_USER_PHOTOS event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.URLS_GET_USER_PHOTOS );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "user",
												  MethodGroupHelper.parseUser );
		}
		
		/**
		 * Returns the url to a user's profile.
		 *
		 * @param user_id (Optional) The NSID of the user to fetch the url for. 
		 *			If omitted, the calling user is assumed.
		 * @see http://www.flickr.com/services/api/flickr.urls.getUserProfile.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getUserProfile( user_id:String = "" ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getUserProfile_result, 
								   "flickr.urls.getUserProfile", 
								   false,
								   new NameValuePair( "user_id", user_id ) );
		}
		
		/**
		 * Capture the result of the getUserProfile call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getUserProfile_result( event:Event ):void {
			// Create a URLS_GET_USER_PROFILE event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.URLS_GET_USER_PROFILE );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "user",
												  MethodGroupHelper.parseUser );
		}
		
		/**
		 * Returns a group NSID, given the url to a group's page or photo pool.
		 *
		 * @param url The url to the group's page or photo pool.
		 * @see http://www.flickr.com/services/api/flickr.urls.lookupGroup.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function lookupGroup( url:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, lookupGroup_result, 
								   "flickr.urls.lookupGroup", 
								   false,
								   new NameValuePair( "url", url ) );
		}
		
		/**
		 * Capture the result of the lookupGroup call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function lookupGroup_result( event:Event ):void {
			// Create a URLS_LOOKUP_GROUP event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.URLS_LOOKUP_GROUP );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "group",
												  MethodGroupHelper.parseGroup );
		}
		
		/**
		 * Returns a user NSID, given the url to a user's photos or profile.
		 *
		 * @param url Thr url to the user's profile or photos page.
		 * @see http://www.flickr.com/services/api/flickr.urls.lookupUser.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function lookupUser( url:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, lookupUser_result, 
								   "flickr.urls.lookupUser", 
								   false,
								   new NameValuePair( "url", url ) );
		}
		
		/**
		 * Capture the result of the lookupUser call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function lookupUser_result( event:Event ):void {
			// Create a URLS_LOOKUP_USER event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.URLS_LOOKUP_USER );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "user",
												  MethodGroupHelper.parseUser );
		}
		
	}	
	
}