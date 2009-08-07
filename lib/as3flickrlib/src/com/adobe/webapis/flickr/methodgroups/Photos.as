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
	
	import com.adobe.webapis.flickr.*;
	import com.adobe.webapis.flickr.events.FlickrResultEvent;
	import com.adobe.webapis.flickr.methodgroups.helpers.PhotoSearchParams;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	
	
		/**
		 * Broadcast as a result of the addTags method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an empty object
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #addTags
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosAddTags", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getAllContexts method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, a PhotoContext instance
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getAllContexts
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosGetAllContexts", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getContactsPhotos method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an Array of Photo instances
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getContactsPhotos
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosGetContactsPhotos", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getContactsPublicPhotos method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an Array of Photo instances
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getContactsPublicPhotos
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosGetContactsPublicPhotos", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getContext method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an Array of Photo instances.  The first
		 *				element is the previous photo, the second element is
		 *				the next photo.
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getContext
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosGetContext", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getCounts method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an array of PhotoCount instances
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getCounts
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosGetCounts", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getExif method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, a Photo instance
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getExif
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosGetExif", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getInfo method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, a Photo instance
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getInfo
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosGetInfo", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getNotInSet method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, a PagedPhotoList instance
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getNotInSet
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosGetNotInSet", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getPerms method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, a Photo instance
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getPerms
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosGetPerms", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getRecent method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, a PagedPhotoList instance
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getRecent
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosGetRecent", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getSizes method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an Array of PhotoSize instances
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getSizes
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosGetSizes", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
		
		/**
		 * Broadcast as a result of the getUntagged method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, a PagedPhotoList instnace
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getUntagged
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */	 
		[Event(name="photosGetUntagged", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the removeTag method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an empty object
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #removeTag
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */	 
		[Event(name="photosRemoveTag", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a search of the search method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, a PagedPhotoList instnace
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #search
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */	 
		[Event(name="photosSearch", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a search of the setDates method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an empty object
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #setDates
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */	 
		[Event(name="photosSetDates", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a search of the setMeta method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an empty object
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #setMeta
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */	 
		[Event(name="photosSetMeta", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a search of the setPerms method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an empty object
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #setPerms
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */	
		[Event(name="photosSetPerms", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a search of the setTags method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an empty object
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #setTags
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */	
		[Event(name="photosSetTags", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]	
	
	/**
	 * Contains the methods for the Photos method group in the Flickr API.
	 * 
	 * Even though the events are listed here, they're really broadcast
	 * from the FlickrService instance itself to make using the service
	 * easier.
	 */
	public class Photos {
			 
		/** 
		 * A reference to the FlickrService that contains the api key
		 * and logic for processing API calls/responses
		 */
		private var _service:FlickrService;
		
		/**
		 * Private variable that we provide read-only access to
		 */
		private var _licenses:Licenses;
		private var _notes:Notes;
		private var _transform:Transform;
		private var _upload:Upload;
	
		/**
		 * Construct a new Blogs "method group" class
		 *
		 * @param service The FlickrService this method group
		 *		is associated with.
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function Photos( service:FlickrService ) {
			_service = service;
			_licenses = new Licenses( service );
			_notes = new Notes( service );
			_transform = new Transform( service );
			_upload = new Upload( service );
		}
		
		/**
		 * Provide read-only access to the Licenses method group in the Flickr API
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get licenses():Licenses {
			return _licenses;	
		}
		
		/**
		 * Provide read-only access to the Notes method group in the Flickr API
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get notes():Notes {
			return _notes;	
		}
		
		/**
		 * Provide read-only access to the Transform method group in the Flickr API
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get transform():Transform {
			return _transform;	
		}
		
		/**
		 * Provide read-only access to the Upload method group in the Flickr API
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get upload():Upload {
			return _upload;	
		}
	
		/**
		 * Add tags to a photo.
		 *
		 * This method requires authentication with WRITE permission.
		 *
		 * @param photo_id The id of the photo to add tags to.
		 * @param tags The tags to add to the photo.
		 * @see http://www.flickr.com/services/api/flickr.photos.addTags.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function addTags( photo_id:String, tags:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, addTags_result, 
								   "flickr.photos.addTags", 
								   false,
								   new NameValuePair( "photo_id", photo_id ),
								   new NameValuePair( "tags", tags ) );
		}
		
		/**
		 * Capture the result of the addTags call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function addTags_result( event:Event ):void {
			// Create a PHOTOS_ADD_TAGS event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_ADD_TAGS );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result );
		}
		
		/**
		 * Returns all visble sets and pools the photo belongs to.
		 *
		 * @param photo_id The photo to return information for.
		 * @see http://www.flickr.com/services/api/flickr.photos.getAllContexts.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getAllContexts( photo_id:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getAllContexts_result, 
								   "flickr.photos.getAllContexts", 
								   false,
								   new NameValuePair( "photo_id", photo_id ) );
		}
		
		/**
		 * Capture the result of the getAllContexts call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getAllContexts_result( event:Event ):void {
			// Create a PHOTOS_GET_ALL_CONTEXTS event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_GET_ALL_CONTEXTS );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "photoContext",
												  MethodGroupHelper.parsePhotoContext );
		}
		
		/**
		 * Fetch a list of recent photos from the calling users' contacts.
		 *
		 * This method requires authentication with READ permission.
		 *
		 * @param count (Optional) Number of photos to return. Defaults to 10, maximum 50. 
		 *			This is only used if single_photo is not passed.
		 * @param just_friends (Optional) Set as true to only show photos from friends and
		 *			family (excluding regular contacts).
		 * @param single_photo (Optional) Only fetch one photo (the latest) per contact, 
		 *			instead of all photos in chronological order.
		 * @param include_self (Optional) Set to true to include photos from the calling user.
		 * @see http://www.flickr.com/services/api/flickr.photos.getContactsPhotos.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getContactsPhotos( count:Number = 10, just_friends:Boolean = false, single_photo:Boolean = false, include_self:Boolean = false ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getContactsPhotos_result, 
								   "flickr.photos.getContactsPhotos", 
								   false,
								   new NameValuePair( "count", count.toString() ),
								   new NameValuePair( "just_friends", just_friends ? "1" : "0" ),
								   new NameValuePair( "single_photo", single_photo ? "1" : "0" ),
								   new NameValuePair( "include_self", include_self ? "1" : "0" ) );
		}
		
		/**
		 * Capture the result of the getContactsPhotos call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getContactsPhotos_result( event:Event ):void {
			// Create a PHOTOS_GET_CONTACTS_PHOTOS event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_GET_CONTACTS_PHOTOS );
			
			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "photos",
												  MethodGroupHelper.parsePhotoList );
		}
		
		/**
		 * Fetch a list of recent public photos from a users' contacts.
		 *
		 * @param user_id The NSID of the user to fetch photos for.
		 * @param count (Optional) Number of photos to return. Defaults to 10, maximum 50. 
		 *			This is only used if single_photo is not passed.
		 * @param just_friends (Optional) Set as true to only show photos from friends and
		 *			family (excluding regular contacts).
		 * @param single_photo (Optional) Only fetch one photo (the latest) per contact, 
		 *			instead of all photos in chronological order.
		 * @param include_self (Optional) Set to true to include photos from user specified
		 *			by user_id
		 * @see http://www.flickr.com/services/api/flickr.photos.getContactsPublicPhotos.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getContactsPublicPhotos( user_id:String, count:Number = 10, just_friends:Boolean = false, single_photo:Boolean = false, include_self:Boolean = false ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getContactsPublicPhotos_result, 
								   "flickr.photos.getContactsPublicPhotos", 
								   false,
								   new NameValuePair( "user_id", user_id ),
								   new NameValuePair( "count", count.toString() ),
								   new NameValuePair( "just_friends", just_friends ? "1" : "0" ),
								   new NameValuePair( "single_photo", single_photo ? "1" : "0" ),
								   new NameValuePair( "include_self", include_self ? "1" : "0" ) );
		}
		
		/**
		 * Capture the result of the getContactsPublicPhotos call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getContactsPublicPhotos_result( event:Event ):void {
			// Create a PHOTOS_GET_CONTACTS_PUBLIC_PHOTOS event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_GET_CONTACTS_PUBLIC_PHOTOS );
			
			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "photos",
												  MethodGroupHelper.parsePhotoList );
		}
		
		/**
		 * Returns next and previous photos for a photo in a photostream.
		 *
		 * @param photo_id The id of the photo to fetch the context for.
		 * @see http://www.flickr.com/services/api/flickr.photos.getContext.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getContext( photo_id:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getContext_result, 
								   "flickr.photos.getContext", 
								   false,
								   new NameValuePair( "photo_id", photo_id ) );
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
			// Create a PHOTOS_GET_CONTEXT event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_GET_CONTEXT );
			
			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "context",
												  MethodGroupHelper.parseContext );
		}
		
		/**
		 * Gets a list of photo counts for the given date ranges for the 
		 * calling user.
		 *
		 * This method requires authentication with READ permission.
		 *
		 * @param dates (Optional) A list of Date objects, specified earliest first
		 * @param taken_dates (Optional) A list of Date objects, specified earliest
		 *				first 
		 * @see http://www.flickr.com/services/api/flickr.photos.getCounts.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 
		 * @tiptext
		 */
		public function getCounts( dates:Array = null, taken_dates:Array = null ):void {
			
			var datesStr:String = "";
			var takenDatesStr:String = ""
			
			// Make sure dates exists so we don't get an error accessing length
			var datesLen:uint = dates == null ? 0 : dates.length;
			// Construct a string to pass to Flickr from the dates
			for ( var i:int = 0; i < datesLen; i++ ) {
				// Add comma as necessary
				if ( i > 0 ) {
					datesStr += ",";	
				}
				// Convert date to # of seconds since midnight January 1, 1970
				datesStr += dates[i].getTime() / 1000;
			}
			
			// Make sure taken dates exists so we don't get an error accessing length
			var takenDatesLen:uint = taken_dates == null ? 0 : taken_dates.length;
			// Construct a string to pass to Flickr from the dates
			for ( i = 0; i < takenDatesLen; i++ ) {
				// Add comma as necessary
				if ( i > 0 ) {
					takenDatesStr += ",";	
				}
				// Convert date to # of milliseconds since midnight January 1, 1970
				takenDatesStr += ( taken_dates[i] as Date ).valueOf().toString();
			}
			
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getCounts_result, 
								   "flickr.photos.getCounts", 
								   false,
								   new NameValuePair( "dates", datesStr ),
								   new NameValuePair( "taken_dates", takenDatesStr ) );
		}
		
		/**
		 * Capture the result of the getCounts call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getCounts_result( event:Event ):void {
			// Create a PHOTOS_GET_COUNTS event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_GET_COUNTS );
			
			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "photoCounts",
												  MethodGroupHelper.parsePhotoCountList );
		}
		
		/**
		 * Retrieves a list of EXIF/TIFF/GPS tags for a given photo. The calling
		 * user must have permission to view the photo.
		 *
		 * @param photo_id The id of the photo to fetch information for.
		 * @param secret (Optional) The secret for the photo. If the correct secret 
		 *			is passed then permissions checking is skipped. This enables 
		 *			the 'sharing' of individual photos by passing around the id 
		 *			and secret.
		 * @see http://www.flickr.com/services/api/flickr.photos.getExif.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getExif( photo_id:String, secret:String = "" ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getExif_result, 
								   "flickr.photos.getExif", 
								   false,
								   new NameValuePair( "photo_id", photo_id ),
								   new NameValuePair( "secret", secret ) );
		}
		
		/**
		 * Capture the result of the getExif call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getExif_result( event:Event ):void {
			// Create a PHOTOS_GET_EXIF event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_GET_EXIF );
			
			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "photo",
												  MethodGroupHelper.parsePhotoExifs );
		}
		
		/**
		 * Get information about a photo. The calling user must have permission to 
		 * view the photo.
		 *
		 * @param photo_id The id of the photo to fetch information for.
		 * @param secret (Optional) The secret for the photo. If the correct secret 
		 *			is passed then permissions checking is skipped. This enables 
		 *			the 'sharing' of individual photos by passing around the id 
		 *			and secret.
		 * @see http://www.flickr.com/services/api/flickr.photos.getInfo.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getInfo( photo_id:String, secret:String = "" ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getInfo_result, 
								   "flickr.photos.getInfo", 
								   false,
								   new NameValuePair( "photo_id", photo_id ),
								   new NameValuePair( "secret", secret ) );
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
			// Create a PHOTOS_GET_INFO event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_GET_INFO );
			
			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "photo",
												  MethodGroupHelper.parsePhoto );
		}
		
		/**
		 * Returns a list of your photos that are not part of any sets.
		 *
		 * This method requires authentication with READ permission.
		 *
		 * @param extras (Optional) A comma-delimited list of extra information to 
		 *			fetch for each returned record. Currently supported fields are:
		 *			license, date_upload, date_taken, owner_name, icon_server, and
		 *			original_format.
		 * @param per_page (Optional) Number of photos to return per page. If this 
		 *			argument is omitted, it defaults to 100. The maximum allowed 
		 *			value is 500.
		 * @param page (Optional) The page of results to return. If this argument 
		 *			is omitted, it defaults to 1.
		 * @see http://www.flickr.com/services/api/flickr.photos.getNotInSet.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getNotInSet( extras:String = "", per_page:Number = 100, page:Number = 1 ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getNotInSet_result, 
								   "flickr.photos.getNotInSet", 
								   false,
								   new NameValuePair( "extras", extras ),
								   new NameValuePair( "per_page", per_page.toString() ),
								   new NameValuePair( "page", page.toString() ) );
		}
		
		/**
		 * Capture the result of the getNotInSet call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getNotInSet_result( event:Event ):void {
			// Create a PHOTOS_GET_NOT_IN_SET event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_GET_NOT_IN_SET );
			
			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "photos",
												  MethodGroupHelper.parsePagedPhotoList );
		}
		
		/**
		 * Get permissions for a photo.
		 *
		 * This method requires authentication with READ permission.
		 *
		 * @param photo_id The id of the photo to get permissions for.
		 * @see http://www.flickr.com/services/api/flickr.photos.getPerms.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getPerms( photo_id:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getPerms_result, 
								   "flickr.photos.getPerms", 
								   false,
								   new NameValuePair( "photo_id", photo_id ) );
		}
		
		/**
		 * Capture the result of the getPerms call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getPerms_result( event:Event ):void {
			// Create a PHOTOS_GET_PERMS event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_GET_PERMS );
			
			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "photo",
												  MethodGroupHelper.parsePhotoPerms );
		}
		
		/**
		 * Returns a list of the latest public photos uploaded to flickr.
		 *
		 * @param extras (Optional) A comma-delimited list of extra information to 
		 *			fetch for each returned record. Currently supported fields are:
		 *			license, date_upload, date_taken, owner_name, icon_server, and
		 *			original_format.
		 * @param per_page (Optional) Number of photos to return per page. If this 
		 *			argument is omitted, it defaults to 100. The maximum allowed 
		 *			value is 500.
		 * @param page (Optional) The page of results to return. If this argument 
		 *			is omitted, it defaults to 1.
		 * @see http://www.flickr.com/services/api/flickr.photos.getRecent.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getRecent( extras:String = "", per_page:Number = 100, page:Number = 1 ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getRecent_result, 
								   "flickr.photos.getRecent", 
								   false,
								   new NameValuePair( "extras", extras ),
								   new NameValuePair( "per_page", per_page.toString() ),
								   new NameValuePair( "page", page.toString() ) );
		}
		
		/**
		 * Capture the result of the getRecent call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getRecent_result( event:Event ):void {
			// Create a PHOTOS_GET_RECENT event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_GET_RECENT );
			
			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "photos",
												  MethodGroupHelper.parsePagedPhotoList );
		}
		
		/**
		 * Returns the available sizes for a photo. The calling user must have 
		 * permission to view the photo.
		 *
		 * @param photo_id The id of the photo to get permissions for.
		 * @see http://www.flickr.com/services/api/flickr.photos.getSizes.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getSizes( photo_id:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getSizes_result, 
								   "flickr.photos.getSizes", 
								   false,
								   new NameValuePair( "photo_id", photo_id ) );
		}
		
		/**
		 * Capture the result of the getSizes call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getSizes_result( event:Event ):void {
			// Create a PHOTOS_GET_SIZES event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_GET_SIZES );
			
			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "photoSizes",
												  MethodGroupHelper.parsePhotoSizeList );
		}
		
		/**
		 * Returns a list of your photos with no tags.
		 *
		 * This method requires authentication with READ permission.
		 *
		 * @param extras (Optional) A comma-delimited list of extra information to 
		 *			fetch for each returned record. Currently supported fields are:
		 *			license, date_upload, date_taken, owner_name, icon_server, and
		 *			original_format.
		 * @param per_page (Optional) Number of photos to return per page. If this 
		 *			argument is omitted, it defaults to 100. The maximum allowed 
		 *			value is 500.
		 * @param page (Optional) The page of results to return. If this argument 
		 *			is omitted, it defaults to 1.
		 * @see http://www.flickr.com/services/api/flickr.photos.getUntagged.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getUntagged( extras:String = "", per_page:Number = 100, page:Number = 1 ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getUntagged_result, 
								   "flickr.photos.getUntagged", 
								   false,
								   new NameValuePair( "extras", extras ),
								   new NameValuePair( "per_page", per_page.toString() ),
								   new NameValuePair( "page", page.toString() ) );
		}
		
		/**
		 * Capture the result of the getUntagged call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getUntagged_result( event:Event ):void {
			// Create a PHOTOS_GET_UNTAGGED event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_GET_UNTAGGED );
			
			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "photos",
												  MethodGroupHelper.parsePagedPhotoList );
		}
		
		/**
		 * Remove a tag from a photo.
		 *
		 * This method requires authentication with WRITE permission.
		 *
		 * @param tag_id The tag to remove from the photo. This parameter should 
		 *			be a tag id such as one returned by flickr.photos.getInfo
		 * @see http://www.flickr.com/services/api/flickr.photos.removeTag.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function removeTag( tag_id:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, removeTag_result, 
								   "flickr.photos.removeTag", 
								   false,
								   new NameValuePair( "tag_id", tag_id ) );
		}
		
		/**
		 * Capture the result of the removeTag call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function removeTag_result( event:Event ):void {
			// Create a PHOTOS_REMOVE_TAG event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_REMOVE_TAG );
			
			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result );
		}
		
		public function searchWithParamHelper(p:PhotoSearchParams):void
		{
			search(p.user_id,
					p.tags,
					p.tag_mode,
					p.text,
					p.min_upload_date,
					p.max_upload_date,
					p.min_taken_date,
					p.max_taken_date,
					p.license,
					p.sort,
					p.privacy_filter,
					p.bbox,
					p.accuracy,
					p.safe_search,
					p.content_type,
					p.machine_tags,
					p.machine_tag_mode,
					p.group_id,
					p.contacts,
					p.woe_id,
					p.place_id,
					p.media,
					p.has_geo,
					p.lat,
					p.lon,
					p.radius,
					p.radius_units,
					p.extras,
					p.per_page,
					p.page);					
		}
		
		/**
		 * Return a list of photos matching some criteria. Only photos visible to 
		 * the calling user will be returned. To return private or semi-private 
		 * photos, the caller must be authenticated with 'read' permissions, and 
		 * have permission to view the photos. Unauthenticated calls will only 
		 * return public photos.
		 *
		 * @param user_id (Optional) The NSID of the user who's photo to search. 
		 *			If this parameter isn't passed then everybody's public photos 
		 *			will be searched.
		 * @param tags (Optional) A comma-delimited list of tags. Photos with one
		 *			or more of the tags listed will be returned.
		 * @param tag_mode (Optional) Either 'any' for an OR combination of tags, 
		 *			or 'all' for an AND combination. Defaults to 'any' if not specified.
		 * @param text (Optional) A free text search. Photos who's title, 
		 *			description or tags contain the text will be returned.
		 * @param min_upload_date (Optional) Minimum upload date. Photos with an 
		 *			upload date greater than or equal to this value will be returned. 
		 * @param max_upload_date (Optional) Maximum upload date. Photos with an 
		 *			upload date less than or equal to this value will be returned.
		 * @param min_taken_date (Optional) Minimum taken date. Photos with an taken
		 *			date greater than or equal to this value will be returned
		 * @param max_taken_date (Optional) Maximum taken date. Photos with an taken
		 *			date less than or equal to this value will be returned.
		 * @param license (Optional) The license id for photos (for possible values 
		 *			see the flickr.photos.licenses.getInfo method).
		 * @param extras (Optional) A comma-delimited list of extra information to 
		 *			fetch for each returned record. Currently supported fields are:
		 *			license, date_upload, date_taken, owner_name, icon_server, and
		 *			original_format.
		 * @param per_page (Optional) Number of photos to return per page. If this 
		 *			argument is omitted, it defaults to 100. The maximum allowed 
		 *			value is 500.
		 * @param page (Optional) The page of results to return. If this argument 
		 *			is omitted, it defaults to 1.
		 * @param sort (Optional) The order in which to sort returned photos. 
		 *			Deafults to date-posted-desc. The possible values are: 
		 *			date-posted-asc, date-posted-desc, date-taken-asc and 
		 *			date-taken-desc.
		 * @see http://www.flickr.com/services/api/flickr.photos.search.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function search( user_id:String = "",
								tags:String = "",
								tag_mode:String = "any", 
								text:String = "",
								min_upload_date:Date = null,
								max_upload_date:Date = null, 
								min_taken_date:Date = null,
								max_taken_date:Date = null,
								license:Number = -1,
								sort:String = "date-posted-desc",
								privacy_filter:int = -1,
								bbox:String = "",
								accuracy:int = -1,
								safe_search:int = -1,
								content_type:int = -1,
								machine_tags:String = "",
								machine_tag_mode:String = "",
								group_id:String = "",
								contacts:String = "",
								woe_id:String = "",
								place_id:String = "",
								media:String = "",
								has_geo:Boolean = false,//true, false or all
								lat:String = "",
								lon:String = "",
								radius:Number = -1,
								radius_units:Number = -1,
								extras:String = "",
								per_page:Number = 100,
								page:Number = 1):void {
			
			
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, search_result, 
								   "flickr.photos.search", 
								   false,
								   new NameValuePair( "user_id", user_id ),
								   new NameValuePair( "tags", tags ),
								   new NameValuePair( "tag_mode", tag_mode ),
								   new NameValuePair( "text", text ),
								   // convert dates to # of milliseconds
								   new NameValuePair( "min_upload_date", min_upload_date == null ? "" : min_upload_date.valueOf().toString() ),
								   new NameValuePair( "max_upload_date", max_upload_date == null ? "" : max_upload_date.valueOf().toString() ),
								   new NameValuePair( "min_taken_date", min_taken_date == null ? "" : min_taken_date.valueOf().toString() ),
								   new NameValuePair( "max_taken_date", max_taken_date == null ? "" : max_taken_date.valueOf().toString() ),
								   new NameValuePair( "license", license == -1 ? "" : license.toString() ),
								   new NameValuePair( "sort", sort ),
								   new NameValuePair( "privacy_filter", privacy_filter == -1 ? "" : privacy_filter.toString() ),
								   new NameValuePair( "bbox", bbox ),
								   new NameValuePair( "accuracy", accuracy == -1 ? "" : accuracy.toString() ),
								   new NameValuePair( "safe_search", safe_search == -1 ? "" : safe_search.toString() ),
								   new NameValuePair( "content_type", content_type == -1 ? "" : content_type.toString() ),
								   new NameValuePair( "machine_tags", machine_tags ),
								   new NameValuePair( "machine_tag_mode", machine_tag_mode ),
								   
								   new NameValuePair( "group_id", group_id ),
								   new NameValuePair( "contacts", contacts ),
								   new NameValuePair( "woe_id", woe_id ),
								   new NameValuePair( "place_id", place_id ),
								   new NameValuePair( "media", media ),
								   
								   new NameValuePair( "has_geo", (has_geo)?"true":"" ),
								   new NameValuePair( "lat", lat ),
								   new NameValuePair( "lon", lon ),
								   new NameValuePair( "radius", radius == -1 ? "" : radius.toString() ),
								   new NameValuePair( "radius_units", radius_units == -1 ? "" : radius_units.toString() ),

								   new NameValuePair( "extras", extras ),
								   new NameValuePair( "per_page", per_page.toString() ),
								   new NameValuePair( "page", page.toString() )
								   );
		}
		
		/**
		 * Capture the result of the search call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function search_result( event:Event ):void {
			// Create a PHOTOS_SEARCH event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_SEARCH );
			
			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "photos",
												  MethodGroupHelper.parsePagedPhotoList );
		}
		
		/**
		 * Set one or both of the dates for a photo.
		 *
		 * This method requires authentication with WRITE permission.
		 *
		 * @param photo_id The id of the photo to edit dates for.
		 * @param date_posted (Optional) The date the photo was uploaded to flickr
		 * @param date_taken (Optional) The date the photo was taken
		 * @param date_taken_granularity (Optional) The granularity of the date 
		 *			the photo was taken
		 * @see http://www.flickr.com/services/api/flickr.photos.setDates.html
		 * @see http://www.flickr.com/services/api/misc.dates.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function setDates( photo_id:String, date_posted:Date = null, date_taken:Date = null, date_taken_granularity:Number = 0 ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, setDates_result, 
								   "flickr.photos.setDates", 
								   false,
								   new NameValuePair( "photo_id", photo_id ),
								   new NameValuePair( "date_posted", MethodGroupHelper.dateToString( date_posted ) ),
								   new NameValuePair( "date_taken", MethodGroupHelper.dateToString( date_taken ) ),
								   new NameValuePair( "date_taken_granularity", date_taken_granularity.toString() ) );
		}
		
		/**
		 * Capture the result of the setDates call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function setDates_result( event:Event ):void {
			// Create a PHOTOS_SET_DATES event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_SET_DATES );
			
			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, URLLoader( event.target ).data, result );
		}
		
		/**
		 * Set the meta information for a photo.
		 *
		 * This method requires authentication with WRITE permission.
		 *
		 * @param photo_id The id of the photo to set information for.
		 * @param title The title for the photo.
		 * @param description The description for the photo.
		 * @see http://www.flickr.com/services/api/flickr.photos.setMeta.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function setMeta( photo_id:String, title:String, description:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, setMeta_result, 
								   "flickr.photos.setMeta", 
								   false,
								   new NameValuePair( "photo_id", photo_id ),
								   new NameValuePair( "title", title ),
								   new NameValuePair( "description", description ) );
		}
		
		/**
		 * Capture the result of the setMeta call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function setMeta_result( event:Event ):void {
			// Create a PHOTOS_SET_META event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_SET_META );
			
			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, URLLoader( event.target ).data, result );
		}
		
		/**
		 * Set permissions for a photo.
		 *
		 * This method requires authentication with WRITE permission.
		 *
		 * @param photo_id The id of the photo to set permissions for.
		 * @param is_public true to set the photo to public, false to set it to private.
		 * @param is_friend true to make the photo visible to friends when private, 
		 *				false to not.
		 * @param is_family true to make the photo visible to family when private, 
		 *				false to not.
		 * @param perm_comment Who can add comments to the photo and it's notes. one of:
		 *				0: nobody
		 *				1: friends & family
		 *				2: contacts
		 *				3: everybody
		 * @param perm_addmeta Who can add notes and tags to the photo. one of:
		 *				0: nobody / just the owner
		 *				1: friends & family
		 *				2: contacts
		 *				3: everybody
		 * @param description The description for the photo.
		 * @see http://www.flickr.com/services/api/flickr.photos.setPerms.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function setPerms( photo_id:String, is_public:Boolean, is_friend:Boolean, 
								  is_family:Boolean, perm_comment:int, perm_addmeta:int ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, setPerms_result, 
								   "flickr.photos.setPerms", 
								   false,
								   new NameValuePair( "photo_id", photo_id ),
								   new NameValuePair( "is_public", is_public ? "1" : "0" ),
								   new NameValuePair( "is_friend", is_friend ? "1" : "0" ),
								   new NameValuePair( "is_family", is_family ? "1" : "0" ),
								   new NameValuePair( "perm_comment", perm_comment.toString() ),
								   new NameValuePair( "perm_addmeta", perm_addmeta.toString() ) );
		}
		
		/**
		 * Capture the result of the setPerms call, and dispatch
		 * the event to anyone listening.
		 *
		 * This method requires authentication with WRITE permission.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function setPerms_result( event:Event ):void {
			// Create a PHOTOS_SET_PERMS event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_SET_PERMS );
			
			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, URLLoader( event.target ).data, result );
		}
		
		/**
		 * Set the tags for a photo.
		 *
		 * @param photo_id The id of the photo to set tags for.
		 * @param tags All tags for the photo (as a single space-delimited string).
		 * @param description The description for the photo.
		 * @see http://www.flickr.com/services/api/flickr.photos.setTags.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function setTags( photo_id:String, tags:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, setTags_result, 
								   "flickr.photos.setTags", 
								   false,
								   new NameValuePair( "photo_id", photo_id ),
								   new NameValuePair( "tags", tags ) );
		}
		
		/**
		 * Capture the result of the setTags call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function setTags_result( event:Event ):void {
			// Create a PHOTOS_SET_TAGS event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_SET_TAGS );
			
			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, URLLoader( event.target ).data, result );
		}
		
	}	
	
}