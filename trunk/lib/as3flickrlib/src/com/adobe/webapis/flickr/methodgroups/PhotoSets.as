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
		 * Broadcast as a result of the addPhoto method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an empty object
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #addPhoto
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosetsAddPhoto", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the create method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, a PhotoSet instance
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #create
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosetsCreate", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the deleteSet method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an empty object
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #deleteSet
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosetsDelete", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the editMeta method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an empty object
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #editMeta
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosetsEditMeta", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the editPhotos method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an empty object
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #editPhotos
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosetsEditPhotos", 
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
		[Event(name="photosetsGetContext", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getInfo method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, a PhotoSet instance
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getInfo
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosetsGetInfo", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getList method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an Array of PhotoSet instnaces
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getList
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosetsGetList", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the getPhotos method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, a PhotoSet instance
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getPhotos
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosetsGetPhotos", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the orderSets method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an empty object
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #orderSets
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosetsOrderSets", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the removePhoto method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an empty object
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #removePhoto
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosetsRemovePhoto", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]	
	
	/**
	 * Contains the methods for the PhotoSets method group in the Flickr API.
	 * 
	 * Even though the events are listed here, they're really broadcast
	 * from the FlickrService instance itself to make using the service
	 * easier.
	 */
	public class PhotoSets {
	
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
		public function PhotoSets( service:FlickrService ) {
			_service = service;
		}
	
		/**
		 * Add a photo to the end of an existing photoset.
		 *
		 * This method requires authentication with WRITE permission.
		 *
		 * @param photoset_id The id of the photoset to add a photo to.
		 * @param photo_id The id of the photo to add to the set.
		 * @see http://www.flickr.com/services/api/flickr.photosets.addPhoto.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function addPhoto( photoset_id:String, photo_id:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, addPhoto_result, 
								   "flickr.photosets.addPhoto", 
								   false,
								   new NameValuePair( "photoset_id", photoset_id ),
								   new NameValuePair( "photo_id", photo_id ) );
		}
		
		/**
		 * Capture the result of the addPhoto call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function addPhoto_result( event:Event ):void {
			// Create a PHOTOSETS_ADD_PHOTO event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOSETS_ADD_PHOTO );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, URLLoader( event.target ).data, result );
		}
		
		/**
		 * Create a new photoset for the calling user.
		 *
		 * This method requires authentication with WRITE permission.
		 *
		 * @param title A title for the photoset.
		 * @param description (Optional) A description of the photoset. May 
		 *				contain limited html.
		 * @param primary_photo_id The id of the photo to represent this set. 
		 *				The photo must belong to the calling user.
		 * @see http://www.flickr.com/services/api/flickr.photosets.create.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function create( title:String, description:String, primary_photo_id:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, create_result, 
								   "flickr.photosets.create", 
								   false,
								   new NameValuePair( "title", title ),
								   new NameValuePair( "description", description ),
								   new NameValuePair( "primary_photo_id", primary_photo_id ) );
		}
		
		/**
		 * Capture the result of the create call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function create_result( event:Event ):void {
			// Create a PHOTOSETS_CREATE event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOSETS_CREATE );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "photoSet",
												  MethodGroupHelper.parsePhotoSet );
		}
		
		/**
		 * Delete a photoset.
		 *
		 * This method requires authentication with WRITE permission.
		 *
		 * @param photoset_id The id of the photoset to delete. It must be 
		 *				owned by the calling user.
		 * @see http://www.flickr.com/services/api/flickr.photosets.delete.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function deleteSet( photoset_id:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, delete_result, 
								   "flickr.photosets.delete", 
								   false,
								   new NameValuePair( "photoset_id", photoset_id ) );
		}
		
		/**
		 * Capture the result of the delete call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function delete_result( event:Event ):void {
			// Create a PHOTOSETS_DELETE event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOSETS_DELETE );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result );
		}
		
		/**
		 * Modify the meta-data for a photoset.
		 *
		 * This method requires authentication with WRITE permission.
		 *
		 * @param photoset_id The id of the photoset to modify.
		 * @param title The new title for the photoset.
		 * @param description (Optional) A description of the photoset. May 
		 *			contain limited html.
		 * @see http://www.flickr.com/services/api/flickr.photosets.editMeta.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function editMeta( photoset_id:String, title:String, description:String = "" ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, editMeta_result, 
								   "flickr.photosets.editMeta", 
								   false,
								   new NameValuePair( "photoset_id", photoset_id ),
								   new NameValuePair( "title", title ),
								   new NameValuePair( "description", description ) );
		}
		
		/**
		 * Capture the result of the editMeta call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function editMeta_result( event:Event ):void {
			// Create a PHOTOSETS_EDIT_META event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOSETS_EDIT_META );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result );
		}
		
		/**
		 * Modify the photos in a photoset. Use this method to add, remove 
		 * and re-order photos.
		 *
		 * This method requires authentication with WRITE permission.
		 *
		 * @param photoset_id The id of the photoset to modify. The photoset must 
		 *			belong to the calling user.
		 * @param primary_photo_id The id of the photo to use as the 'primary' photo 
		 * 			for the set. This id must also be passed along in photo_ids 
		 *			list argument.
		 * @param photo_ids An array of photo ids (number or string) to include in the set. 
		 *			They will appear in the set in the order sent. This list must 
		 *			contain the primary photo id. All photos must belong to the owner 
		 *			of the set. This list of photos replaces the existing list. 
		 *			Call flickr.photosets.addPhoto to append a photo to a set.
		 * @see http://www.flickr.com/services/api/flickr.photosets.editPhotos.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function editPhotos( photoset_id:String, primary_photo_id:String, photo_ids:Array ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, editPhotos_result, 
								   "flickr.photosets.editPhotos", 
								   false,
								   new NameValuePair( "photoset_id", photoset_id ),
								   new NameValuePair( "primary_photo_id", primary_photo_id ),
								   new NameValuePair( "photo_ids", photo_ids.join(",") ) );
		}
		
		/**
		 * Capture the result of the editPhotos call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function editPhotos_result( event:Event ):void {
			// Create a PHOTOSETS_EDIT_PHOTOS event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOSETS_EDIT_PHOTOS );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, URLLoader( event.target ).data, result );
		}
		
		/**
		 * Returns next and previous photos for a photo in a set.
		 *
		 * @param photo_id The id of the photo to fetch the context for.
		 * @param photoset_id The id of the photoset for which to fetch the 
		 *			photo's context.
		 * @see http://www.flickr.com/services/api/flickr.photosets.getContext.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getContext( photo_id:String, photoset_id:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getContext_result, 
								   "flickr.photosets.getContext", 
								   false,
								   new NameValuePair( "photo_id", photo_id ),
								   new NameValuePair( "photoset_id", photoset_id ) );
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
			// Create a PHOTOSETS_GET_CONTEXT event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOSETS_GET_CONTEXT );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "context",
												  MethodGroupHelper.parseContext );
		}
		
		/**
		 * Returns next and previous photos for a photo in a set.
		 *
		 * @param photoset_id The ID of the photoset to fetch information for.
		 * @see http://www.flickr.com/services/api/flickr.photosets.getInfo.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getInfo( photoset_id:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getInfo_result, 
								   "flickr.photosets.getInfo", 
								   false,
								   new NameValuePair( "photoset_id", photoset_id ) );
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
			// Create a PHOTOSETS_GET_INFO event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOSETS_GET_INFO );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "photoSet",
												  MethodGroupHelper.parsePhotoSet );
		}
		
		/**
		 * Returns the photosets belonging to the specified user.
		 *
		 * @param user_id The NSID of the user to get a photoset list for. If 
		 *			none is specified, the calling user is assumed.
		 * @see http://www.flickr.com/services/api/flickr.photosets.getList.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getList( user_id:String = "" ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getList_result, 
								   "flickr.photosets.getList", 
								   false,
								   new NameValuePair( "user_id", user_id ) );
		}
		
		/**
		 * Capture the result of the getList call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function getList_result( event:Event ):void {
			// Create a PHOTOSETS_GET_LIST event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOSETS_GET_LIST );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "photoSets",
												  MethodGroupHelper.parsePhotoSetList );
		}
		
		/**
		 * Get the list of photos in a set.
		 *
		 * @param photoset_id The id of the photoset to return the photos for.
		 * @see http://www.flickr.com/services/api/flickr.photosets.getPhotos.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getPhotos( photoset_id:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, getPhotos_result, 
								   "flickr.photosets.getPhotos", 
								   false,
								   new NameValuePair( "photoset_id", photoset_id ) );
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
			// Create a PHOTOSETS_GET_PHOTOS event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOSETS_GET_PHOTOS );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "photoSet",
												  MethodGroupHelper.parsePhotoSet );
		}
		
		/**
		 * Set the order of photosets for the calling user.
		 *
		 * This method requires authentication with WRITE permission.
		 *
		 * @param photoset_ids An array of photoset IDs (number or string), ordered
		 *			with the set to show first, first in the list. Any set IDs not
		 *			given in the list will be set to appear at the end of the list, 
		 *			ordered by their IDs.
		 * @see http://www.flickr.com/services/api/flickr.photosets.orderSets.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function orderSets( photoset_ids:Array ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, orderSets_result, 
								   "flickr.photosets.orderSets", 
								   false,
								   new NameValuePair( "photoset_ids", photoset_ids.join(",") ) );
		}
		
		/**
		 * Capture the result of the orderSets call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function orderSets_result( event:Event ):void {
			// Create a PHOTOSETS_ORDER_SETS event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOSETS_ORDER_SETS );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result );
		}
		
		/**
		 * Remove a photo from a photoset.
		 *
		 * This method requires authentication with WRITE permission.
		 *
		 * @param photoset_id The id of the photoset to remove a photo from.
		 * @param photo_id The id of the photo to remove from the set.
		 * @see http://www.flickr.com/services/api/flickr.photosets.removePhoto.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function removePhoto( photoset_id:String, photo_id:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, removePhoto_result, 
								   "flickr.photosets.removePhoto", 
								   false,
								   new NameValuePair( "photoset_id", photoset_id ),
								   new NameValuePair( "photo_id", photo_id ) );
		}
		
		/**
		 * Capture the result of the removePhoto call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function removePhoto_result( event:Event ):void {
			// Create a PHOTOSETS_REMOVE_PHOTO event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOSETS_REMOVE_PHOTO );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result );
		}
		
	}	
	
}