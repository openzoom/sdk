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
	 * Group is a ValueObject for the Flickr API.
	 */
	public class Group {
		
		private var _nsid:String;
		private var _name:String;
		private var _description:String;
		private var _privacy:int;
		private var _members:int;
		private var _online:int;
		private var _chatNsid:String;
		private var _inChat:int;
		private var _isEighteenPlus:Boolean;
		private var _isAdmin:Boolean;
		private var _photos:int;
		private var _iconServer:int;
		private var _url:String;
		
		/**
		 * Construct a new Group instance
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function Group() {
			// do nothing
		}	
		
		/**
		 * The nsid of the group
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get nsid():String {
			return _nsid;
		}
		
		public function set nsid( value:String ):void {
			_nsid = value;
		}
		
		/**
		 * The name of the group
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get name():String {
			return _name;
		}
		
		public function set name( value:String ):void {
			_name = value;
		}
		
		/**
		 * The description of the group
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get description():String {
			return _description;
		}
		
		public function set description( value:String ):void {
			_description = value;
		}
		
		/**
		 * The privacy of the group
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get privacy():int {
			return _privacy;
		}
		
		public function set privacy( value:int ):void {
			_privacy = value;
		}
		
		/**
		 * The members in the group
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get members():int {
			return _members;
		}
		
		public function set members( value:int ):void {
			_members = value;
		}
		
		/**
		 * The number of group members online
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get online():int {
			return _online;
		}
		
		public function set online( value:int ):void {
			_online = value;
		}
		
		/**
		 * The chatNsid of the group
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get chatNsid():String {
			return _chatNsid;
		}
		
		public function set chatNsid( value:String ):void {
			_chatNsid = value;
		}
		
		/**
		 * The number of people in the group chat
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get inChat():int {
			return _inChat;
		}
		
		public function set inChat( value:int ):void {
			_inChat = value;
		}
		
		/**
		 * Flag for if the group is 18+ or not
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get isEighteenPlus():Boolean {
			return _isEighteenPlus;	
		}
		
		public function set isEighteenPlus( value:Boolean ):void {
			_isEighteenPlus = value;	
		}
		
		/**
		 * Flag for if the current user is the admin of the group
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get isAdmin():Boolean {
			return _isAdmin;	
		}
		
		public function set isAdmin( value:Boolean ):void {
			_isAdmin = value;	
		}
		
		/**
		 * The number of photos in the group
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get photos():int {
			return _photos;	
		}
		
		public function set photos( value:int ):void {
			_photos = value;	
		}
		
		/**
		 * The icon server of the group
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get iconServer():int {
			return _iconServer;
		}
		
		public function set iconServer( value:int ):void {
			_iconServer = value;
		}
		
		/**
		 * The url of the group
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get url():String {
			return _url;
		}
		
		public function set url( value:String ):void {
			_url = value;
		}
		
	}
}