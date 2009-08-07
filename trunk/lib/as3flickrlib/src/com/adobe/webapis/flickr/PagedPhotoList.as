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

package com.adobe.webapis.flickr {
	
	/**
	 * PagedPhotoList is a ValueObject for the Flickr API.
	 */
	public class PagedPhotoList {
		
		private var _page:int;
		private var _pages:int;
		private var _perPage:int;
		private var _total:int;
		private var _photos:Array;
		
		/**
		 * Construct a new PagedPhotoList instance
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function PagedPhotoList() {
			_photos = new Array();
		}
		
		/**
		 * The current page of photos
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get page():int {
			return _page;
		}
		
		public function set page( value:int ):void {
			_page = value;	
		}
		
		/**
		 * The number of photo pages
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get pages():int {
			return _pages;
		}
		
		public function set pages( value:int ):void {
			_pages = value;	
		}
		
		/**
		 * The number of photos per page
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get perPage():int {
			return _perPage;
		}
		
		public function set perPage( value:int ):void {
			_perPage = value;	
		}
		
		/**
		 * The total number of photos
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get total():int {
			return _total;
		}
		
		public function set total( value:int ):void {
			_total = value;	
		}
		
		/**
		 * The container holding the Photo instances
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get photos():Array {
			return _photos;
		}
		
		public function set photos( value:Array ):void {
			_photos = value;	
		}
				
	}
}