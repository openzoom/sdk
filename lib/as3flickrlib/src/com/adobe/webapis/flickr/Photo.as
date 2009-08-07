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
	 * Photo is a ValueObject for the Flickr API.
	 */
	public class Photo {
		
		private var _id:String;
		private var _ownerId:String;
		private var _ownerName:String;
		private var _secret:String;
		private var _server:int;
		private var _iconServer:int;
		private var _title:String;
		private var _description:String;
		private var _commentCount:int;
		private var _isPublic:Boolean;
		private var _isFriend:Boolean;
		private var _isFamily:Boolean;
		private var _license:int;
		private var _dateUploaded:Date;
		private var _dateTaken:Date;
		private var _dateAdded:Date;
		private var _originalFormat:String;
		private var _url:String;
		private var _exifs:Array;
		private var _rotation:int;
		private var _ownerRealName:String;
		private var _ownerLocation:String;
		private var _isFavorite:Boolean;
		private var _commentPermission:int;
		private var _addMetaPermission:int;
		private var _canComment:int;
		private var _canAddMeta:int;
		private var _notes:Array;
		private var _tags:Array;
		private var _urls:Array;
		
		/**
		 * Construct a new Photo instance
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function Photo() {
			_exifs = new Array();
			_notes = new Array();
			_tags = new Array();
			_urls = new Array();
		}	
		
		/**
		 * The server farm id of the photo
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */		
		public var farmId:int;
		
		/**
		 * The secret necessary to retrieve original source of photos
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */			
		public var originalSecret:String;
		
		/**
		 * The original width of the image
		 */
		public var originalWidth : Number
		
		/**
		 * The original width of the image
		 */
		public var originalHeight : Number
	
		/**
		 * The latitude that the image was taken at.
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */			
		public var latitude:String;
		
		/**
		 * The longitude that the image was taken at.
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */			
		public var longitude:String;
		
		
		/**
		 * The id of the photo
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
		 * The id of owner of the photo
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get ownerId():String {
			return _ownerId;
		}
		
		public function set ownerId( value:String ):void {
			_ownerId = value;
		}
		
		/**
		 * The name of owner of the photo
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get ownerName():String {
			return _ownerName;
		}
		
		public function set ownerName( value:String ):void {
			_ownerName = value;
		}
		
		/**
		 * The photo secret
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get secret():String {
			return _secret;
		}
		
		public function set secret( value:String ):void {
			_secret = value;
		}
		
		/**
		 * The server of the photo
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get server():int {
			return _server;
		}
		
		public function set server( value:int ):void {
			_server = value;
		}		
		
		/**
		 * The icon server of the photo
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
		 * The title of the photo
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get title():String {
			return _title;
		}
		
		public function set title( value:String ):void {
			_title = value;
		}
		
		/**
		 * The description of the photo
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
		 * The number of comments on the photo
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get commentCount():int {
			return _commentCount;
		}
		
		public function set commentCount( value:int ):void {
			_commentCount = value;
		}
		
		/**
		 * Flag for the photo having public access
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get isPublic():Boolean {
			return _isPublic;
		}
		
		public function set isPublic( value:Boolean ):void {
			_isPublic = value;
		}
		
		/**
		 * Flag for the photo having friend access
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
		 * Flag for the photo having family access
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
		 * The license of the photo, corresponding
		 * to a constant in the License class
		 *
		 * @see com.adobe.webapis.flickr.License
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get license():int {
			return _license;
		}
		
		public function set license( value:int ):void {
			_license = value;
		}
		
		/**
		 * The upload date of the photo
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get dateUploaded():Date {
			return _dateUploaded;
		}
		
		public function set dateUploaded( value:Date ):void {
			_dateUploaded = value;
		}
		
		/**
		 * The date the photo was taken
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get dateTaken():Date {
			return _dateTaken;
		}
		
		public function set dateTaken( value:Date ):void {
			_dateTaken = value;
		}
		
		/**
		 * The date the photo was added to Flickr
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get dateAdded():Date {
			return _dateAdded;
		}
		
		public function set dateAdded( value:Date ):void {
			_dateAdded = value;
		}
		
		/**
		 * The original format of the photo
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get originalFormat():String {
			return _originalFormat;
		}
		
		public function set originalFormat( value:String ):void {
			_originalFormat = value;
		}
		
		/**
		 * The url of the photo (when dealing with context)
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
		 * The exifs of the photo
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get exifs():Array {
			return _exifs;
		}
		
		public function set exifs( value:Array ):void {
			_exifs = value;
		}
		
		/**
		 * The rotation of the photo
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get rotation():int {
			return _rotation;
		}
		
		public function set rotation( value:int ):void {
			_rotation = value;
		}
		
		/**
		 * The owner of the photo's real name
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get ownerRealName():String {
			return _ownerRealName;
		}
		
		public function set ownerRealName( value:String ):void {
			_ownerRealName = value;
		}
		
		/**
		 * The location of the photo's owner
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get ownerLocation():String {
			return _ownerLocation;
		}
		
		public function set ownerLocation( value:String ):void {
			_ownerLocation = value;
		}
		
		/**
		 * Whether or not the photo is a favorite
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get isFavorite():Boolean {
			return _isFavorite;
		}
		
		public function set isFavorite( value:Boolean ):void {
			_isFavorite = value;
		}
		
		/**
		 * The comment permission for the photo
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get commentPermission():int {
			return _commentPermission;
		}
		
		public function set commentPermission( value:int ):void {
			_commentPermission = value;
		}
		
		/**
		 * The add meta permission for the photo
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get addMetaPermission():int {
			return _addMetaPermission;
		}
		
		public function set addMetaPermission( value:int ):void {
			_addMetaPermission = value;
		}
		
		/**
		 * Whether or not the user can comment
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get canComment():int {
			return _canComment;
		}
		
		public function set canComment( value:int ):void {
			_canComment = value;
		}
		
		/**
		 * Whether or not the user can add meta data
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get canAddMeta():int {
			return _canAddMeta;
		}
		
		public function set canAddMeta( value:int ):void {
			_canAddMeta = value;
		}

		/**
		 * The notes for the photo - array of PhotoNote
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get notes():Array {
			return _notes;
		}
		
		public function set notes( value:Array ):void {
			_notes = value;
		}
		
		/**
		 * The tags for the photo - array of PhotoTag
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
		
		/**
		 * The urls for the photo - array of PhotoUrl
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function get urls():Array {
			return _urls;
		}
		
		public function set urls( value:Array ):void {
			_urls = value;
		}
		
	}
}