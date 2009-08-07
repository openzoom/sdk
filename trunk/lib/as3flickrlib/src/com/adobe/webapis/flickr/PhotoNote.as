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
	
	import flash.geom.Rectangle;
	
	/**
	 * PhotoNote is a ValueObject for the Flickr API.  It describes
	 * the location and position of a note on an image.
	 */
	public class PhotoNote {
		
		private var _id:String;
		private var _authorId:String;
		private var _authorName:String;
		private var _rectangle:Rectangle;
		private var _note:String;
		
		/**
		 * Construct a new PhotoNote instance
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function PhotoNote() {
			// do nothing
		}
		
		/**
		 * The id of the note
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get id():String {
			return _id;
		}
		
		public function set id( value:String ):void {
			_id = value;
		}
		
		/**
		 * The id of the author of the note
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get authorId():String {
			return _authorId;
		}
		
		public function set authorId( value:String ):void {
			_authorId = value;
		}
		
		/**
		 * The name of the author of the note
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get authorName():String {
			return _authorName;
		}
		
		public function set authorName( value:String ):void {
			_authorName = value;
		}
		
		/**
		 * The bounding rectangle of the note
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get rectangle():Rectangle {
			return _rectangle;
		}
		
		public function set rectangle( value:Rectangle ):void {
			_rectangle = value;
		}
		
		/**
		 * The contents of the note
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get note():String {
			return _note;
		}
		
		public function set note( value:String ):void {
			_note = value;
		}
	
	}
}