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
		 * Broadcast as a result of the findByEmail method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, a User instance
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #findByEmail
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="peopleFindByEmail", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the findByUsername method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, a User instance
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #findByUsername
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="peopleFindByUsername", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getInfo method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, a User instance
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getInfo
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="peopleGetInfo", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getPublicGroups method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an Array of Group instances
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getPublicGroups
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="peopleGetPublicGroups", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getPublicPhotos method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, a PagedPhotoList instance
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getPublicPhotos
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="peopleGetPublicPhotos", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			
		/**
		 * Broadcast as a result of the getUploadStatus method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, a User instance
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getUploadStatus
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="peopleGetUploadStatus", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]	
	
	/**
	 * Contains the methods for the People method group in the Flickr API.
	 * 
	 * Even though the events are listed here, they're really broadcast
	 * from the FlickrService instance itself to make using the service
	 * easier.
	 */
	public class People {
				 
		/** 
		 * A reference to the FlickrService that contains the api key
		 * and logic for processing API calls/responses
		 */
		private var _service:FlickrService;
	
		/**
		 * Construct a new People "method group" class
		 *
		 * @param service The FlickrService this method group
		 *		is associated with.
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function People( service:FlickrService ) {
			_service = service;
		}
	
		/**
		 * Return a user's NSID, given their email address
		 *
		 * @param find_email The email address of the user to find (may be primary
		 *			 or secondary).
		 * @see http://www.flickr.com/services/api/flickr.people.findByEmail.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function findByEmail( find_email:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, findByEmail_result, 
								   "flickr.people.findByEmail", 
								   false,
								   new NameValuePair( "find_email", find_email ) );
		}
		
		/**
		 * Capture the result of the findByEmail call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function findByEmail_result( event:Event ):void {
			// Create a PEOPLE_FIND_BY_EMAIL event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PEOPLE_FIND_BY_EMAIL );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "user",
												  MethodGroupHelper.parseUser );
		}
		
		/**
		 * Return a user's NSID, given their username.
		 *
		 * @param username The username of the user to lookup.
		 * @see http://www.flickr.com/services/api/flickr.people.findByUsername.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function findByUsername( username:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, findByUsername_result, 
								   "flickr.people.findByUsername", 
								   false,
								   new NameValuePair( "username", username ) );
		}
		
		/**
		 * Capture the result of the findByUsername call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function findByUsername_result( event:Event ):void {
			// Create a PEOPLE_FIND_BY_USERNAME event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PEOPLE_FIND_BY_USERNAME );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "user",
												  MethodGroupHelper.parseUser );
		}
		
		/**
		 * Get information about a user.
		 *
		 * @param user_id The NSID of the user to fetch information about.
		 * @see http://www.flickr.com/services/api/flickr.people.getInfo.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getInfo( user_id:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getInfo_result, 
								   "flickr.people.getInfo", 
								   false,
								   new NameValuePair( "user_id", user_id ) );
		}
		
		/**
		 * Capture the result of the getInfo call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getInfo_result( event:Event ):void {
			// Create a PEOPLE_GET_INFO event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PEOPLE_GET_INFO );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "user",
												  MethodGroupHelper.parsePerson );
		}
		
		/**
		 * Returns the list of public groups a user is a member of.
		 *
		 * @param user_id The NSID of the user to fetch groups for.
		 * @see http://www.flickr.com/services/api/flickr.people.getPublicGroups.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getPublicGroups( user_id:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getPublicGroups_result, 
								   "flickr.people.getPublicGroups", 
								   false,
								   new NameValuePair( "user_id", user_id ) );
		}
		
		/**
		 * Capture the result of the getPublicGroups call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getPublicGroups_result( event:Event ):void {
			// Create a PEOPLE_GET_PUBLIC_GROUPS event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PEOPLE_GET_PUBLIC_GROUPS );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "groups",
												  MethodGroupHelper.parseGroupList );
		}
		
		/**
		 * Gets a list of public photos for the given user.
		 *
		 * @param user_id The NSID of the user who's photos to return.
		 * @param extras (Optional) A comma-delimited list of extra information to fetch
		 *			for each returned record. Currently supported fields are: 
		 *			license, date_upload, date_taken, owner_name, icon_server.
		 * @param per_page (Optional) Number of photos to return per page. If this argument
		 *			is omitted, it defaults to 100. The maximum allowed value is 500.
		 * @param page (Optional) The page of results to return. If this argument is 
		 *			omitted, it defaults to 1.
		 * @see http://www.flickr.com/services/api/flickr.people.getPublicPhotos.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getPublicPhotos( user_id:String, extras:String = "", per_page:Number = 100, page:Number = 1 ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getPublicPhotos_result, 
								   "flickr.people.getPublicPhotos", 
								   false,
								   new NameValuePair( "user_id", user_id ),
								   new NameValuePair( "extras", extras ),
								   new NameValuePair( "per_page", per_page.toString() ),
								   new NameValuePair( "page", page.toString() ) );
		}
		
		/**
		 * Capture the result of the getPublicPhotos call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getPublicPhotos_result( event:Event ):void {
			// Create a PEOPLE_GET_PUBLIC_PHOTOS event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PEOPLE_GET_PUBLIC_PHOTOS );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "photos",
												  MethodGroupHelper.parsePagedPhotoList );
		}
		
		/**
		 * Returns information for the calling used related to photo uploads.
		 *
		 * This method requires authentication with READ permission.
		 *
		 * @see http://www.flickr.com/services/api/flickr.people.getUploadStatus.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getUploadStatus(  ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getUploadStatus_result, 
								   "flickr.people.getUploadStatus", 
								   false );
		}
		
		/**
		 * Capture the result of the getUploadStatus call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getUploadStatus_result( event:Event ):void {
			// Create a PEOPLE_GET_UPLOAD_STATUS event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PEOPLE_GET_UPLOAD_STATUS );

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