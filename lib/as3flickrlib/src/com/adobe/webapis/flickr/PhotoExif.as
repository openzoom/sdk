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
	 * PhotoExif is a ValueObject for the Flickr API.
	 */
	public class PhotoExif {
		
		private var _tagspace:String;
		private var _tagspaceId:int;
		private var _tag:int;
		private var _label:String;
		private var _raw:String;
		private var _clean:String;
		
		/**
		 * Construct a new PhotoExif instance
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function PhotoExif() {
			// do nothing
		}
		
		/**
		 * The tagspace of the photo exif
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get tagspace():String {
			return _tagspace;
		}
		
		public function set tagspace( value:String ):void {
			_tagspace = value;
		}
		
		/**
		 * The tagspace id of the photo exif
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get tagspaceId():int {
			return _tagspaceId;
		}
		
		public function set tagspaceId( value:int ):void {
			_tagspaceId = value;
		}

		/**
		 * The tag of the photo exif
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get tag():int {
			return _tag;
		}
		
		public function set tag( value:int ):void {
			_tag = value;
		}
		
		/**
		 * The label of the photo exif
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get label():String {
			return _label;
		}
		
		public function set label( value:String ):void {
			_label = value;
		}
		
		/**
		 * The raw of the photo exif
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get raw():String {
			return _raw;
		}
		
		public function set raw( value:String ):void {
			_raw = value;
		}
		
		/**
		 * The clean of the photo exif
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get clean():String {
			return _clean;
		}
		
		public function set clean( value:String ):void {
			_clean = value;
		}						
	}
}