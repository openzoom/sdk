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
		 * Broadcast as a result of the add method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an empty object
		 *
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #add
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="groupsPoolsAdd", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getContext method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an array of length 2 of Photo instances.
		 *				The first element is the previous photo, the second element
		 *				is the next photo.
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getContext
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="groupsPoolsGetContext", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getGroups method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an Array of Group instances
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getGroups
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="groupsPoolsGetGroups", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getPhotos method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, a PagedPhotoList instance
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getPhotos
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="groupsPoolsGetPhotos", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the remove method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an empty object
		 *
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #remove
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="groupsPoolsRemove", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
	
	/**
	 * Contains the methods for the Pools method group in the Flickr API.
	 * 
	 * Even though the events are listed here, they're really broadcast
	 * from the FlickrService instance itself to make using the service
	 * easier.
	 */
	public class Pools {
	
		/** 
		 * A reference to the FlickrService that contains the api key
		 * and logic for processing API calls/responses
		 */
		private var _service:FlickrService;
	
		/**
		 * Construct a new Pools "method group" class
		 *
		 * @param service The FlickrService this method group
		 *		is associated with.
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function Pools( service:FlickrService ) {
			_service = service;
		}
	
		/**
		 * Add a photo to a group's pool.
		 *
		 * This method requires authentication with WRITE permission.
		 *
		 * @param photo_id The id of the photo to add to the group pool. The photo 
		 *			must belong to the calling user.
		 * @param group_id The NSID of the group who's pool the photo is to 
		 			be added to.
		 * @see http://www.flickr.com/services/api/flickr.groups.pools.add.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function add( photo_id:String, group_id:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, add_result, 
								   "flickr.groups.pools.add",
								   false,
								   new NameValuePair( "photo_id", photo_id ),
								   new NameValuePair( "group_id", group_id ) );
		}
		
		/**
		 * Capture the result of the add call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function add_result( event:Event ):void {
			// Create a GROUPS_POOLS_ADD event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.GROUPS_POOLS_ADD );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result );
		}
		
		/**
		 * Returns next and previous photos for a photo in a group pool.
		 *
		 * @param photo_id The id of the photo to fetch the context for.
		 * @param group_id The NSID of the group who's pool to fetch the photo's 
		 *				context for.
		 * @see http://www.flickr.com/services/api/flickr.groups.pools.getContext.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getContext( photo_id:String, group_id:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getContext_result, 
								   "flickr.groups.pools.getContext",
								   false,
								   new NameValuePair( "photo_id", photo_id ),
								   new NameValuePair( "group_id", group_id ) );
		}
		
		/**
		 * Capture the result of the getContext call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getContext_result( event:Event ):void {
			// Create a GROUPS_POOLS_GET_CONTEXT event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.GROUPS_POOLS_GET_CONTEXT );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "context",
												  MethodGroupHelper.parseContext );
		}
		
		/**
		 * Returns a list of groups to which you can add photos.
		 *
		 * This method requires authentication with READ permission.
		 *
		 * @see http://www.flickr.com/services/api/flickr.groups.pools.getGroups.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getGroups():void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getGroups_result, 
								   "flickr.groups.pools.getGroups",
								   false );
		}
		
		/**
		 * Capture the result of the getGroups call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getGroups_result( event:Event ):void {
			// Create a GROUPS_POOLS_GET_GROUPS event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.GROUPS_POOLS_GET_GROUPS );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "groups",
												  MethodGroupHelper.parseGroupList );
		}
		
		/**
		 * Returns a list of pool photos for a given group, based on the permissions of
		 * the group and the user logged in (if any).
		 *
		 * @param group_id The id of the group who's pool you which to get the photo 
		 *			list for.
		 * @param tags (Optional) A tag to filter the pool with. At the moment only 
		 *			one tag at a time is supported.
		 * @param extras (Optional) A comma-delimited list of extra information to 
		 *			fetch for each returned record. Currently supported fields are: 
		 *			license, date_upload, date_taken, owner_name, icon_server.
		 * @param per_page (Optional) Number of photos to return per page. If this 
		 *			argument is omitted, it defaults to 100. The maximum allowed 
		 *			value is 500.
		 * @param page (Optional) The page of results to return. If this argument 
		 *			is omitted, it defaults to 1.
		 * @see http://www.flickr.com/services/api/flickr.groups.pools.getPhotos.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getPhotos( group_id:String, tags:String = "", extras:String = "", per_page:Number = 100, page:Number = 1 ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getPhotos_result, 
								   "flickr.groups.pools.getPhotos",
								   false,
								   new NameValuePair( "group_id", group_id ),
								   new NameValuePair( "tags", tags ),
								   new NameValuePair( "extras", extras ),
								   new NameValuePair( "per_page", per_page.toString() ),
								   new NameValuePair( "page", page.toString() ) );
		}
		
		/**
		 * Capture the result of the getPhotos call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getPhotos_result( event:Event ):void {
			// Create a GROUPS_POOLS_GET_PHOTOS event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.GROUPS_POOLS_GET_PHOTOS );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "photos",
												  MethodGroupHelper.parsePagedPhotoList );
		}
		
		/**
		 * Remove a photo from a group pool.
		 *
		 * This method requires authentication with WRITE permission.
		 *
		 * @param photo_id The id of the photo to remove from the group pool. The photo
		 *			must either be owned by the calling user of the calling user must
		 *			be an administrator of the group.
		 * @param group_id The NSID of the group who's pool the photo is to 
		 			be removed from.
		 * @see http://www.flickr.com/services/api/flickr.groups.pools.remove.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function remove( photo_id:String, group_id:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, remove_result, 
								   "flickr.groups.pools.remove",
								   false,
								   new NameValuePair( "photo_id", photo_id ),
								   new NameValuePair( "group_id", group_id ) );
		}
		
		/**
		 * Capture the result of the remove call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function remove_result( event:Event ):void {
			// Create a GROUPS_POOLS_REMOVE event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.GROUPS_POOLS_REMOVE );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result );
		}
	}	
	
}