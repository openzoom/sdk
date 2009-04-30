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
		 * Broadcast as a result of the getList method being called
		 *
		 * The event contains the following properties
		 *	success	- Boolean indicating if the call was successful or not
		 *	data - When success is true, an empty object
		 *		   When success is false, contains an "error" FlickrError instance
		 *
		 * @see #getList
		 * @see com.adobe.service.flickr.FlickrError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		[Event(name="interestingnessGetList", 
			 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
			 
	
	/**
	 * Contains the methods for the Interestingness method group in the Flickr API.
	 * 
	 * Even though the events are listed here, they're really broadcast
	 * from the FlickrService instance itself to make using the service
	 * easier.
	 */
	public class Interestingness {
			 
		/** 
		 * A reference to the FlickrService that contains the api key
		 * and logic for processing API calls/responses
		 */
		private var _service:FlickrService;
			
		/**
		 * Construct a new Interestingness "method group" class
		 *
		 * @param service The FlickrService this method group
		 *		is associated with.
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function Interestingness( service:FlickrService ) {
			_service = service;
		}
		
		/**
		 * Returns the list of interesting photos for the most recent day or a user-specified date.
		 *
		 * @param date (Optional) A specific date, to return interesting photos for.
		 * @param extras (Optional) A comma-delimited list of extra information to 
		 *			fetch for each returned record. Currently supported fields are:
		 *			license, date_upload, date_taken, owner_name, icon_server, and
		 *			original_format.
		 * @param per_page (Optional) Number of photos to return per page. If this 
		 *			argument is omitted, it defaults to 100. The maximum allowed 
		 *			value is 500.
		 * @param page (Optional) The page of results to return. If this argument 
		 *			is omitted, it defaults to 1.
		 * @see http://www.flickr.com/services/api/flickr.interestingness.getList.html
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function getList( date:Date = null, extras:String = "", per_page:Number = 100, page:Number = 1 ):void {
			// Let the Helper do the work to invoke the method	
			var dateStr:String = "";
			if (date != null) {
				var fullMonth:String = (date.getMonth() + 1).toString();
				if (date.getMonth() <= 9)
					fullMonth = "0" + fullMonth;
				var fullDay:String = date.getDate().toString();
				if (date.getDate() <= 9)
					fullDay = "0" + fullDay;
				dateStr = date.getFullYear() + "-" + fullMonth + "-" + fullDay;
			}
			
			MethodGroupHelper.invokeMethod( _service, getList_result, 
								   "flickr.interestingness.getList", 
								   false,
								   new NameValuePair( "date", dateStr ),
								   new NameValuePair( "extras", extras ),
								   new NameValuePair( "per_page", per_page.toString() ),
								   new NameValuePair( "page", page.toString() ) );
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
			// Create a INTERESTINGNESS_GET_LIST event
			var result:FlickrResultEvent = new FlickrResultEvent( FlickrResultEvent.INTERESTINGNESS_GET_LIST );
			
			// Have the Helper handle parsing the result from the server - get the data
			// from the URLLoader which correspondes to the result from the API call
			MethodGroupHelper.processAndDispatch( _service, 
												  URLLoader( event.target ).data, 
												  result,
												  "photos",
												  MethodGroupHelper.parsePagedPhotoList );
		}

	}	
	
}