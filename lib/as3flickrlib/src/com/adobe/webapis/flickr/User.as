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
	 * User is a ValueObject for the Flickr API.
	 */
	[RemoteClass(alias="com.adobe.webapis.flickr.User")]
	public class User {
		
		private var _nsid:String;
		private var _username:String;
		private var _fullname:String;
		private var _isPro:Boolean;
		private var _bandwidthMax:Number;
		private var _bandwidthUsed:Number;
		private var _filesizeMax:Number;
		private var _url:String;
		private var _isIgnored:Boolean;
		private var _isFriend:Boolean;
		private var _isFamily:Boolean;
		private var _isAdmin:Boolean;
		private var _iconServer:int;
		private var _mboxSha1Sum:String;
		private var _location:String;
		private var _photoUrl:String;
		private var _profileUrl:String;
		private var _firstPhotoUploadDate:Date;
		private var _firstPhotoTakenDate:Date;
		private var _photoCount:int;
		private var _tags:Array;
		
		
		
		public var iconFarm:int;
		
		/**
		 * Construct a new User instance
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function User() {
			_tags = new Array();
		}	
		
		/**
		 * The NSID of the user
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
		 * The username of the user
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get username():String {
			return _username;
		}
		
		public function set username( value:String ):void {
			_username = value;
		}
		
		/**
		 * The full name of the user
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get fullname():String {
			return _fullname;
		}
		
		public function set fullname( value:String ):void {
			_fullname = value;
		}
		
		/**
		 * Flag if the user has a pro account
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get isPro():Boolean {
			return _isPro;
		}
		
		public function set isPro( value:Boolean ):void {
			_isPro = value;
		}
		
		/**
		 * The max bandwidth for the user
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get bandwidthMax():Number {
			return _bandwidthMax;
		}
		
		public function set bandwidthMax( value:Number ):void {
			_bandwidthMax = value;
		}
		
		/**
		 * The used bandwidth for the user
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get bandwidthUsed():Number {
			return _bandwidthUsed;
		}
		
		public function set bandwidthUsed( value:Number ):void {
			_bandwidthUsed = value;
		}
		
		/**
		 * The max filesize of an image for the user
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get filesizeMax():Number {
			return _filesizeMax;
		}
		
		public function set filesizeMax( value:Number ):void {
			_filesizeMax = value;
		}
		
		/**
		 * The url for the user's flickr page
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
		
		/**
		 * Flag if the user is ignored
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get isIgnored():Boolean {
			return _isIgnored;	
		}
		
		public function set isIgnored( value:Boolean ):void {
			_isIgnored = value;
		}
		
		/**
		 * Flag if the user is family
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get isFamily():Boolean {
			return _isFamily;	
		}
		
		public function set isFamily( value:Boolean ):void {
			_isFamily = value;
		}
		
		/**
		 * Flag if the user is friend
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get isFriend():Boolean {
			return _isFriend;
		}
		
		public function set isFriend( value:Boolean ):void {
			_isFriend = value;
		}
		
		/**
		 * Flag if the user is an admin
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
		 * The icon server of the user
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
		 * The sha1 sum of the mailbox of the user
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get mboxSha1Sum():String {
			return _mboxSha1Sum;
		}
		
		public function set mboxSha1Sum( value:String ):void {
			_mboxSha1Sum = value;
		}
		
		/**
		 * The location of the user
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get location():String {
			return _location;
		}
		
		public function set location( value:String ):void {
			_location = value;
		}
		
		/**
		 * The photo url of the user
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get photoUrl():String {
			return _photoUrl;
		}
		
		public function set photoUrl( value:String ):void {
			_photoUrl = value;
		}
		
		/**
		 * The profile url of the user
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get profileUrl():String {
			return _profileUrl;
		}
		
		public function set profileUrl( value:String ):void {
			_profileUrl = value;
		}
		
		/**
		 * The date of the user's first photo upload
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get firstPhotoUploadDate():Date {
			return _firstPhotoUploadDate;
		}
		
		public function set firstPhotoUploadDate( value:Date ):void {
			_firstPhotoUploadDate = value;
		}
		
		/**
		 * The date of the user's first photo taken
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get firstPhotoTakenDate():Date {
			return _firstPhotoTakenDate;
		}
		
		public function set firstPhotoTakenDate( value:Date ):void {
			_firstPhotoTakenDate = value;
		}
		
		/**
		 * The number of photos uploaded by the user
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get photoCount():int {
			return _photoCount;
		}
		
		public function set photoCount( value:int ):void {
			_photoCount = value;
		}
		
		/**
		 * The tags of the user
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get tags():Array {
			return _tags;
		}
		
		public function set tags( value:Array ):void {
			_tags = value;
		}
		
	}
	
}