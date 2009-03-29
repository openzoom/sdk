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
	import flash.geom.Rectangle;
	
		/**
		 * Broadcast as a result of the add method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, a PhotoNote instnace
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #add
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosNotesAdd", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the deleteNote method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an empty object
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #deleteNote
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosNotesDelete", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
		/**
		 * Broadcast as a result of the edit method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an empty object
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #edit
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="photosNotesEdit", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]	
	
	/**
	 * Contains the methods for the Notes method group in the Flickr API.
	 * 
	 * Even though the events are listed here, they're really broadcast
	 * from the FlickrService instance itself to make using the service
	 * easier.
	 */
	public class Notes {
			 
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
		public function Notes( service:FlickrService ) {
			_service = service;
		}
	
		/**
		 * Add a note to a photo. Coordinates and sizes are in pixels, based on the 
		 * 500px image size shown on individual photo pages.
		 *
		 * This method requires authentication with WRITE permission.
		 *
		 * @param photo_id The id of the photo to add a note to
		 * @param note_rect  The Rectangle bounding box (x, y, width, height) for the note
		 * @param note_text The description of the note
		 * @param degrees The amount of degrees by which to rotate the photo (clockwise)
		 *			from it's current orientation. Valid values are 90, 180 and 270.
		 * @see http://www.flickr.com/services/api/flickr.photos.notes.add.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function add( photo_id:String, note_rect:Rectangle, note_text:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, add_result, 
								   "flickr.photos.notes.add", 
								   false,
								   new NameValuePair( "photo_id", photo_id ),
								   new NameValuePair( "note_x", note_rect.x.toString() ),
								   new NameValuePair( "note_y", note_rect.y.toString() ),
								   new NameValuePair( "note_width", note_rect.width.toString() ),
								   new NameValuePair( "note_height", note_rect.height.toString() ),
								   new NameValuePair( "note_text", note_text ) );
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
			// Create a PHOTOS_NOTES_ADD event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_NOTES_ADD );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "note",
												  MethodGroupHelper.parsePhotoNote );
		}
		
		/**
		 * Delete a note from a photo.
		 *
		 * This method requires authentication with WRITE permission.
		 *
		 * @param note_id The id of the note to delete
		 * @see http://www.flickr.com/services/api/flickr.photos.notes.delete.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function deleteNote( note_id:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, delete_result, 
								   "flickr.photos.notes.delete", 
								   false,
								   new NameValuePair( "note_id", note_id ) );
		}
		
		/**
		 * Capture the result of the deleteNote call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function delete_result( event:Event ):void {
			// Create a PHOTOS_NOTES_DELETE event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_NOTES_DELETE );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result );
		}
		
		/**
		 * Edit a note on a photo. Coordinates and sizes are in pixels, based on the 500px
		 * image size shown on individual photo pages.
		 *
		 * This method requires authentication with WRITE permission.
		 *
		 * @param noteid The id of the note to edit
		 * @param note_rect  The Rectangle bounding box (x, y, width, height) for the note
		 * @param note_text The description of the note
		 * @param degrees The amount of degrees by which to rotate the photo (clockwise)
		 *			from it's current orientation. Valid values are 90, 180 and 270.
		 * @see http://www.flickr.com/services/api/flickr.photos.notes.edit.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function edit( note_id:String, note_rect:Rectangle, note_text:String ):void {
			// Let the Helper do the work to invoke the method			
			MethodGroupHelper.invokeMethod( _service, edit_result, 
								   "flickr.photos.notes.edit", 
								   false,
								   new NameValuePair( "note_id", note_id ),
								   new NameValuePair( "note_x", note_rect.x.toString() ),
								   new NameValuePair( "note_y", note_rect.y.toString() ),
								   new NameValuePair( "note_width", note_rect.width.toString() ),
								   new NameValuePair( "note_height", note_rect.height.toString() ),
								   new NameValuePair( "note_text", note_text ) );
		}
		
		/**
		 * Capture the result of the edit call, and dispatch
		 * the event to anyone listening.
		 *
		 * @param event The complete event generated by the URLLoader
		 * 			that was used to communicate with the Flickr API
		 *			from the invokeMethod method in MethodGroupHelper
		 */
		private function edit_result( event:Event ):void {
			// Create a PHOTOS_NOTES_EDIT event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.PHOTOS_NOTES_EDIT );

			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, URLLoader( event.target ).data, result );
		}
		
	}	
	
}