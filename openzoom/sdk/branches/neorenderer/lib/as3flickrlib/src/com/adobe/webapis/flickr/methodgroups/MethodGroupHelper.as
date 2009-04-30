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
	
	import com.adobe.crypto.MD5;
	import com.adobe.webapis.flickr.*;
	import com.adobe.webapis.flickr.events.*;
	
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.*;
	
	/**
	 * Contains helper functions for the method group classes that are
	 * reused throughout them.
	 */
	internal class MethodGroupHelper {
	
		/**
		 * Reusable method that the "method group" classes can call to invoke a
		 * method on the API.
		 *
		 * @param callBack The function to be notified when the RPC is complete
		 * @param method The name of the method to invoke ( like flickr.test.echo )
		 * @param signed A boolean value indicating if the method call needs
		 *			an api_sig attached to it
		 * @param params An array of NameValuePair or primitive elements to pass
		 *			as parameters to the remote method
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		internal static function invokeMethod( service:FlickrService, 
												callBack:Function, method:String, 
												signed:Boolean, ... params:Array ):void
		{
			
			// Create an array to store our name/value pairs
			// for the query because during signing we need to sort
			// these alphabetically
			var args:Array = new Array();
			
			args.push( new NameValuePair( "api_key", service.api_key ) );
			args.push( new NameValuePair( "method", method ) );
			
			
			// Loop over the params and add them as arguments
			for ( var i:int = 0; i < params.length; i++ ) {
				// Do we have an argument name, or do we create one
				if ( params[i] is NameValuePair ) {
					args.push( params[i] );
				} else {
					// Create a unique argument name using our loop counter
					args.push( new NameValuePair( "param" + i, params[i].toString() ) );
				}
			}
			
			// If a user is authenticated, automatically add their token
			if ( service.permission != AuthPerm.NONE && service.token ) {
				args.push( new NameValuePair( "auth_token", service.token ) );
				// auto-sign the call because the user is authenticated
				signed = true;
			}
			
			// Sign the call if we have to, or if the user is logged in
			if ( signed ) {
				
				// sign the call according to the documentation point #8
				// here: http://www.flickr.com/services/api/auth.spec.html
				args.sortOn( "name" );
				var sig:String = service.secret;
				for ( var j:int = 0; j < args.length; j++ ) {
					sig += args[j].name.toString() + args[j].value.toString();	
				}	
				args.push( new NameValuePair( "api_sig", MD5.hash( sig ) ) );
			}
			
			// Construct the query string to send to the Flickr service
			var query:String = "";
			for ( var k:int = 0; k < args.length; k++ ) {
				// This puts 1 too many "&" on the end, but that doesn't
				// affect the flickr call, so it doesn't matter
				query += args[k].name + "=" + args[k].value + "&";	
			}
			
			// Use the "internal" flickrservice namespace to be able to
			// access the urlLoader so we can make the request.
			var loader:URLLoader = service.flickrservice_internal::urlLoader;
			
			// Construct a url request with our query string and invoke
			// the Flickr method
			loader.addEventListener( "complete", callBack );
			loader.load( new URLRequest( FlickrService.END_POINT + query ) );
		}
		
		/**
		 * Handle processing the result of the API call.
		 *
		 * @param service The FlickrService associated with the method group
		 * @param response The XML response we got from the loader call
		 * @param result The event to fill in the details of and dispatch
		 * @param propertyName The property in event.data that the results should be placed
		 * @param parseFunction The function to parse the response XML with
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		internal static function processAndDispatch( service:FlickrService, response:String, result:FlickrResultEvent, propertyName:String = "", parseFunction:Function = null ):void {
			// Process the response to create an object for return values
			var rsp:Object = processResponse( response, propertyName, parseFunction );

			// Copy some properties from the response to the result event
			result.success = rsp.success;
			result.data = rsp.data;

			// Notify everyone listening
			service.dispatchEvent( result );
		}
		
		/**
		 * Reusable method that the "method group" classes can call
		 * to process the results of the Flickr method.
		 *
		 * @param flickrResponse The rest response string that aligns
		 *		with the documentation here: 
		 *			http://www.flickr.com/services/api/response.rest.html
		 * @param parseFunction A reference to the function that should be used
		 *		to parse the XML received from the server
		 * @param propertyName The name of the property to put the parsed data in.
		 *  	For example, the result object will contain a "data" property that
		 * 		will contain an additional property (the value of propertyName) that
		 * 		contains the actual data.
		 * @return An object with success and data properties.  Success
		 *		will be true if the call was completed, false otherwise.
		 *		Data will contain ether an array of NameValuePair (if
		 *		successful) or errorCode and errorMessage properties.
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		internal static function processResponse( flickrResponse:String, propertyName:String, parseFunction:Function ):Object {
			var result:Object = new Object();
			result.data = new Object();
			
			// Use an XMLDocument to convert a string to XML
			var doc:XMLDocument = new XMLDocument();
			doc.ignoreWhite = true;
			doc.parseXML( flickrResponse );
						
			// Get the root rsp node from the document
			var rsp:XMLNode = doc.firstChild;
			
			// Clean up a little
			doc = null; 
			
			if ( rsp.attributes.stat == "ok" ) {
				result.success = true;
				
				// Parse the XML object into a user-defined class (This gives us
				// nice code hinting, and abstracts away the FlickrAPI a bit - if
				// the FlickrAPI changes responses we can modify this service
				// without the user having to update their program code
				if ( parseFunction == null ) {
					// No parse function speficied, just pass through the XML data.
					// Construct an object that we can access via E4X since
					// the result we get back from Flickr is an xml response
					result.data = XML( rsp );
				} else {
					result.data[propertyName] = parseFunction( XML( rsp ) );	
				}			
								
			} else {
				result.success = false;
				
				
				// In the event that we don't get an xml object
				// as part of the error returned, just
				// use the plain text as the error message
				
				var error:FlickrError = new FlickrError();
				if ( rsp.firstChild != null ) 
				{
					error.errorCode = int( rsp.firstChild.attributes.code );
					error.errorMessage = rsp.firstChild.attributes.msg;
					
					result.data.error = error;
				}
				else 
				{
					error.errorCode = -1;
					error.errorMessage = rsp.nodeValue;
					
					result.data.error = error;
				}
				
			}
			
			
			return result;			
		}
		
		/**
		 * Converts a date object into a Flickr date string
		 *
		 * @param date The date to convert
		 * @return A string representing the date in a format
		 *		that Flickr understands
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		internal static function dateToString( date:Date ):String {
			// Don't do anything if the date is invalid
			if ( date == null ) {
				return "";
			} else {
				return date.getFullYear() + "-" + (date.getMonth() + 1)
					+ "-" + date.getDate() + " " + date.getHours()
					+ ":" + date.getMinutes() + ":" + date.getSeconds();
			}
		}
		
		/**
		 * Converts a Flickr date string into a date object
		 *
		 * @param date The string to convert
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		internal static function stringToDate( str:String = "" ):Date {
			if ( str == "" ) {
				return null;
			}
			
			var date:Date = new Date();
			// split the date into date / time parts
			var parts:Array = str.split( " " );
			
			// See if we have the xxxx-xx-xx xx:xx:xx format
			if ( parts.length == 2 ) {
				var dateParts:Array = parts[0].split( "-" );
				var timeParts:Array = parts[1].split( ":" );
				
				date.setFullYear( dateParts[0] );
				date.setMonth( dateParts[1] - 1 ); // subtract 1 (Jan == 0)
				date.setDate( dateParts[2] );
				date.setHours( timeParts[0] );
				date.setMinutes( timeParts[1] );
				date.setSeconds( timeParts[2] );
			} else {
				// Create a date based on # of seconds since Jan 1, 1970 GMT
				date.setTime( parseInt( str ) * 1000 );
			}
			
			return date;
		}
		
		/**
		 * Converts an auth result XML object into an AuthResult instance
		 */
		internal static function parseAuthResult( xml:XML ):AuthResult {
			var authResult:AuthResult = new AuthResult();
			authResult.token = xml.auth.token.toString();
			authResult.perms = xml.auth.perms.toString();
			authResult.user = new User();
			authResult.user.nsid = xml.auth.user.@nsid.toString();
			authResult.user.username = xml.auth.user.@username.toString();
			authResult.user.fullname = xml.auth.user.@fullname.toString();
			return authResult;
		}
		
		/**
		 * Converts a frob XML object into a string (the frob value)
		 */
		internal static function parseFrob( xml:XML ):String {
			return xml.frob.toString();	
		}
		
		/**
		 * Converts a blog list XML object into an arry of Blog instances
		 */
		internal static function parseBlogList( xml:XML ):Array {
			var blogs:Array = new Array();
			
			for each ( var b:XML in xml.blogs.blog ) {
				var blog:Blog = new Blog();
				blog.id = b.@id.toString();
				blog.name = b.@name.toString();
				blog.needsPassword = b.@needspassword.toString() == "1";
				blog.url = b.@url.toString();	
				
				blogs.push( blog );
			}
			
			return blogs;
		}
		
		/**
		 * Converts a contact list XML object into an array of User instances
		 */
		internal static function parseContactList( xml:XML ):Array {
			var contacts:Array = new Array();
			
			for each ( var c:XML in xml.contacts.contact ) {
				var contact:User = new User();
				contact.nsid = c.@nsid.toString();
				contact.username = c.@username.toString();
				contact.fullname = c.@realname.toString();
				contact.isFriend = c.@friend.toString() == "1";
				contact.isFamily = c.@family.toString() == "1";
				contact.isIgnored = c.@ignored.toString() == "1";
				
				contacts.push( contact );
			}
			
			return contacts;	
		}
		
		/**
		 * Converts a pages photo list XML object into a PagesPhotoList instance
		 */
		internal static function parsePagedPhotoList( xml:XML ):PagedPhotoList {
			var pagedPhotoList:PagedPhotoList = new PagedPhotoList();
			
			pagedPhotoList.page = parseInt( xml.photos.@page );
			pagedPhotoList.pages = parseInt( xml.photos.@pages );
			pagedPhotoList.perPage = parseInt( xml.photos.@perpage );
			pagedPhotoList.total = parseInt( xml.photos.@total );
			
			var photos:Array = new Array();
			for each ( var p:XML in xml.photos.photo ) {
				var photo:Photo = new Photo();
				photo.id = p.@id.toString();
				photo.ownerId = p.@owner.toString();
				photo.secret = p.@secret.toString();
				photo.server = parseInt( p.@server );
				photo.latitude = p.@latitude;
				photo.longitude = p.@longitude;
				photo.farmId = parseInt( p.@farm );
				photo.title = p.@title.toString();
				photo.isPublic = p.@ispublic.toString() == "1";
				photo.isFriend = p.@isfriend.toString() == "1";
				photo.isFamily = p.@isfamily.toString() == "1";
				if ( p.@license.toString() ) {
					photo.license = parseInt( p.@license );
				}
				photo.dateUploaded = stringToDate( p.@dateupload.toString() );
				photo.dateTaken = stringToDate( p.@datetaken.toString() );
				photo.dateAdded = stringToDate( p.@dateadded.toString() );
				photo.ownerName = p.@ownername.toString();
				if ( p.@iconserver.toString() ) {
					photo.iconServer = parseInt( p.@iconserver );
				}
				
				photo.originalSecret = p.@originalsecret.toString();
				photo.originalFormat = p.@originalformat.toString();
				
				if( p.hasOwnProperty("@o_width") )
				    photo.originalWidth = p.@o_width
				    
				if( p.hasOwnProperty("@o_height") )
				    photo.originalHeight = p.@o_height
				
				photos.push( photo );
			}
			
			pagedPhotoList.photos = photos;
			return pagedPhotoList;
		}
		
		/**
		 * Converts a group category XML object into a Category instance
		 */
		internal static function parseGroupCategory( xml:XML ):Category {
			var category:Category = new Category();
			
			category.name = xml.category.@name.toString();
			category.path = xml.category.@path.toString();
			category.pathIds = xml.category.@pathids.toString();
			
			// Build sub categories
			for each ( var subcat:XML in xml.category.subcat ) {
				var subcategory:Category = new Category();
				subcategory.id = subcat.@id.toString();
				subcategory.name = subcat.@name.toString();
				subcategory.count = parseInt( subcat.@count );
				
				category.subCategories.push( subcategory );
			}
			
			// Build groups
			for each ( var g:XML in xml.category.group ) {
				var group:Group = new Group();
				group.nsid = g.@id.toString();
				group.name = g.@name.toString();
				group.members = parseInt( g.@members );
				group.online = parseInt( g.@online );
				group.chatNsid = g.@chatnsid.toString();
				group.inChat = parseInt( g.@inchat );
				
				category.groups.push( group );	
			}
			
			return category;
		}
		
		/**
		 * Converts a group XML object into a Group instance
		 */
		internal static function parseGroup( xml:XML ):Group {
			var group:Group = new Group();
			
			group.nsid = xml.group.@id.toString();
			if ( group.nsid == "" ) {
				group.nsid = xml.group.@nsid.toString();	
			}
			group.name = xml.group.name.toString();
			if ( group.name == "" ) {
				group.name = xml.group.groupname.toString();
			}
			group.description = xml.group.description.toString();
			if ( xml.group.members.toString() ) {
				group.members = parseInt( xml.group.members );
			}
			if ( xml.group.privacy.toString() ) {
				group.privacy = parseInt( xml.group.privacy );
			}
			group.url = xml.group.@url.toString()
			
			return group;
		}
		
		/**
		 * Converts a paged group list XML object into a PagedGroupList instance
		 */
		internal static function parsePagedGroupList( xml:XML ):PagedGroupList {
			var pagedGroupList:PagedGroupList = new PagedGroupList();
			
			pagedGroupList.page = parseInt( xml.groups.@page );
			pagedGroupList.pages = parseInt( xml.groups.@pages );
			pagedGroupList.perPage = parseInt( xml.groups.@perpage );
			pagedGroupList.total = parseInt( xml.groups.@total );
			
			for each ( var g:XML in xml.groups.group ) {
				var group:Group = new Group();
				group.nsid = g.@nsid.toString();
				group.name = g.@name.toString();
				group.isEighteenPlus = g.@eighteenplus.toString() == "1";
				
				pagedGroupList.groups.push( group );
			}
			
			
			return pagedGroupList;
		}
		
		/**
		 * Converts a context XML object into an Array of Photo instances.
		 * The first element is the previous photo, the second element is
		 * the next photo.
		 */
		internal static function parseContext( xml:XML ):Array {
			var context:Array = new Array();
			
			var photo:Photo = new Photo();
			photo.id = xml.prevphoto.@id.toString();
			photo.secret = xml.prevphoto.@secret.toString();
			photo.title = xml.prevphoto.@title.toString();
			photo.url = xml.prevphoto.@url.toString();
			
			context.push( photo );
			
			photo = new Photo();
			photo.id = xml.nextphoto.@id.toString();
			photo.secret = xml.nextphoto.@secret.toString();
			photo.title = xml.nextphoto.@title.toString();
			photo.url = xml.nextphoto.@url.toString();
			
			context.push( photo );
			
			return context;
		}
		
		/**
		 * Converts a group list XML object into an Array of Group instances.
		 */
		internal static function parseGroupList( xml:XML ):Array {
			var groups:Array = new Array();
			
			for each ( var g:XML in xml.groups.group ) {
				var group:Group = new Group();
				group.nsid = g.@nsid.toString();
				group.name = g.@name.toString();
				group.isAdmin = g.@admin.toString == "1";
				if ( g.@privacy.toString() ) {
					group.privacy = parseInt( g.@privacy );
				}
				if ( g.@photos.toString() ) {
					group.photos = parseInt( g.@photos );
				}
				if ( g.@iconserver.toString() ) {
					group.iconServer = parseInt( g.@iconserver );
				}
				
				groups.push( group );	
			}
			
			return groups;
		}
		
		/**
		 * Converts a user XML object into a User instance
		 */
		internal static function parseUser( xml:XML ):User {
			var user:User = new User();
			
			// Either nsid or id will be defined, try nsid first
			user.nsid = xml.user.@nsid.toString();
			if ( user.nsid.length == 0 ) {
				user.nsid = xml.user.@id.toString();
			}
			user.username = xml.user.username.toString();
			user.isPro = xml.user.@ispro.toString() == "1";
			user.bandwidthMax = Number( xml.user.bandwidth.@max.toString() );
			user.bandwidthUsed = Number( xml.user.bandwidth.@used.toString() );
			user.filesizeMax = Number( xml.user.filesize.@max.toString() );
			user.url = xml.user.@url.toString();
			
			return user;	
		}
		
		/**
		 * Converts a person XML object into a User instance
		 */
		internal static function parsePerson( xml:XML ):User {
			var user:User = new User();
			
			user.nsid = xml.person.@nsid.toString();
			user.isAdmin = xml.person.@isadmin.toString() == "1";
			user.isPro = xml.person.@ispro.toString() == "1";
			user.iconServer = parseInt( xml.person.@iconserver );
			user.iconFarm = parseInt( xml.person.@iconfarm );
			user.username = xml.person.username.toString();
			user.fullname = xml.person.realname.toString();
			user.mboxSha1Sum = xml.person.mbox_sha1sum.toString();
			user.location = xml.person.location.toString();
			user.photoUrl = xml.person.photosurl.toString();
			user.profileUrl = xml.person.profileurl.toString();
			user.firstPhotoUploadDate = stringToDate( xml.person.photos.firstdate.toString() );
			user.firstPhotoTakenDate = stringToDate( xml.person.photos.firstdatetaken.toString() );
			user.photoCount = parseInt( xml.person.photos.count );
			
			return user;	
		}
		
		/**
		 * Converts a photo context XML object into a PhotoContext instance
		 */
		internal static function parsePhotoContext( xml:XML ):PhotoContext {
		 	var photoContext:PhotoContext = new PhotoContext();
		 	
		 	for each ( var s:XML in xml.set ) {
		 		var photoSet:PhotoSet = new PhotoSet();
		 		photoSet.id = s.@id.toString();
		 		photoSet.title = s.@title.toString();
		 		
		 		photoContext.sets.push( photoSet );
		 	}
		 	
		 	for each ( var p:XML in xml.pool ) {
		 		var photoPool:PhotoPool = new PhotoPool();
		 		photoPool.id = p.@id.toString();
		 		photoPool.title = p.@title.toString();
		 		
		 		photoContext.pools.push( photoPool );
		 	}
		 	
		 	return photoContext;	
		 }
		 
		 /**
		  * Converts a photo list XML object into an Array of Photo instances
		  */
		 internal static function parsePhotoList( xml:XML ):Array {
		 	var photos:Array = new Array();
		 	
		 	for each ( var p:XML in xml.photos.photo ) {
				var photo:Photo = new Photo();
				photo.id = p.@id.toString();
				photo.farmId = parseInt(p.@farm);
				photo.ownerId = p.@owner.toString();
				photo.secret = p.@secret.toString();
				photo.server = parseInt( p.@server );
				photo.ownerName = p.@username.toString();
				photo.title = p.@title.toString();
								
				photos.push( photo );
			}
			
			return photos;	
		}
		
		/**
		 * Converts a photo context XML object into a PhotoContext instance
		 */
		internal static function parsePhotoCountList( xml:XML ):Array {
			var photoCounts:Array = new Array();
			
			for each ( var p:XML in xml.photocounts.photocount ) {
				var photoCount:PhotoCount = new PhotoCount();
				photoCount.count = parseInt( p.@count );
				photoCount.fromDate = stringToDate( p.@fromdate.toString() ); 
				photoCount.toDate = stringToDate( p.@todate.toString() );
				
				photoCounts.push( photoCount );
			}
			
			return photoCounts;
		}
		
		/**
		 * Converts a photo exif list XML object into a Photo instance
		 */
		internal static function parsePhotoExifs( xml:XML ):Photo {
			var photo:Photo = new Photo();
			
			photo.id = xml.photo.@id.toString();
			photo.secret = xml.photo.@secret.toString();
			photo.server = parseInt( xml.photo.@server );
			
			for each ( var e:XML in xml.photo.exif ) {
				var photoExif:PhotoExif = new PhotoExif();
				photoExif.tag = parseInt( e.@tag );
				photoExif.tagspaceId = parseInt( e.@tagspaceid );
				photoExif.tagspace = e.@tagspace.toString();
				photoExif.label = e.@label.toString();
				photoExif.raw = e.raw.toString();
				photoExif.clean = e.clean.toString();
				
				photo.exifs.push( photoExif );	
			}
			
			return photo;
		}
		
		/**
		 * Converts a photo XML object into a Photo instance
		 */
		internal static function parsePhoto( xml:XML ):Photo {
			var photo:Photo = new Photo();
			
			photo.id = xml.photo.@id.toString();
			photo.farmId = parseInt(xml.photo.@farm);
			photo.secret = xml.photo.@secret.toString();
			if ( xml.photo.@server.toString() ) {
				photo.server = parseInt( xml.photo.@server );
			}
			photo.isFavorite = xml.photo.@isfavorite.toString == "1";
			if ( xml.photo.@license.toString() ) {
				photo.license = parseInt( xml.photo.@license );
			}
			if ( xml.photo.@rotation.toString() ) {
				photo.rotation = parseInt( xml.photo.@rotation );
			}
			photo.originalFormat = xml.photo.@originalformat.toString();
			photo.ownerId = xml.photo.owner.@nsid.toString();
			photo.ownerName = xml.photo.owner.@username.toString();
			photo.ownerRealName = xml.photo.owner.@realname.toString();
			photo.ownerLocation = xml.photo.owner.@location.toString();
			photo.title = xml.photo.title.toString();
			photo.description = xml.photo.description.toString();
			if ( xml.photo.permissions.@permcomment.toString() ) {
				photo.commentPermission = parseInt( xml.photo.permissions.@permcomment );	
			}
			if ( xml.photo.permissions.@permaddmeta.toString() ) {
				photo.addMetaPermission = parseInt( xml.photo.permissions.@permaddmeta );
			}
			photo.dateAdded = stringToDate( xml.photo.dates.@posted.toString() );
			photo.dateTaken = stringToDate( xml.photo.dates.@taken.toString() );
			if ( xml.photo.editability.@cancomment.toString() ) {
				photo.canComment = parseInt( xml.photo.editability.@cancomment )
			}
			if ( xml.photo.editability.@canaddmeta.toString() ) {
				photo.canAddMeta = parseInt( xml.photo.editability.@canaddmeta )
			}
			if ( xml.photo.comments.toString() ) {
				photo.commentCount = parseInt( xml.photo.comments );
			}
			
			for each ( var n:XML in xml.photo.notes.note ) {
				var photoNote:PhotoNote = new PhotoNote();
				photoNote.id = n.@id.toString();
				photoNote.authorId = n.@author.toString();
				photoNote.authorName = n.@authorname.toString();
				photoNote.rectangle = new Rectangle();
				photoNote.rectangle.x = parseInt( n.@x );
				photoNote.rectangle.y = parseInt( n.@y );
				photoNote.rectangle.width = parseInt( n.@w );
				photoNote.rectangle.height = parseInt( n.@h );
				photoNote.note = n.toString();
				
				photo.notes.push( photoNote );	
			}
			
			for each ( var t:XML in xml.photo.tags.tag ) {
				var photoTag:PhotoTag = new PhotoTag();
				photoTag.id = t.@id.toString();
				photoTag.authorId = t.@author.toString();
				photoTag.raw = t.@raw.toString();
				photoTag.tag = t.toString();
				
				photo.tags.push( photoTag );
			}
			
			for each ( var u:XML in xml.photo.urls.url ) {
				var photoUrl:PhotoUrl = new PhotoUrl();
				photoUrl.type = u.@type.toString();
				photoUrl.url = u.toString();
				
				photo.urls.push( photoUrl );
			}
			
			return photo;
		}
		
		/**
		 * Converts a photo perm XML object into a Photo instance
		 */
		internal static function parsePhotoPerms( xml:XML ):Photo {
			var photo:Photo = new Photo();
			
			photo.id = xml.perms.@id.toString();
			photo.isPublic = xml.perms.@ispublic.toString() == "1";
			photo.isFriend = xml.perms.@isfriend.toString() == "1";
			photo.isFamily = xml.perms.@isfamily.toString() == "1";
			photo.canComment = parseInt( xml.perms.@permcomment );
			photo.canAddMeta = parseInt( xml.perms.@permaddmeta );
			
			return photo;
		}
		
		/**
		 * Converts a size list XML object into an array of PhotoSize instances
		 */
		internal static function parsePhotoSizeList( xml:XML ):Array {
			var photoSizes:Array = new Array();
			
			for each ( var s:XML in xml.sizes.size ) {
				var photoSize:PhotoSize = new PhotoSize();
				photoSize.label = s.@label.toString();
				photoSize.width = parseInt( s.@width );
				photoSize.height = parseInt( s.@height );
				photoSize.source = s.@source.toString();
				photoSize.url = s.@url.toString();
				
				photoSizes.push( photoSize );	
			}
			
			return photoSizes;
		}
		
		/**
		 * Converts a license list XML object into an array of License instances
		 */
		internal static function parseLicenseList( xml:XML ):Array {
			var licenses:Array = new Array();
			
			for each ( var l:XML in xml.licenses.license ) {
				var license:License = new License();
				license.id = parseInt( l.@id );
				license.name = l.@name.toString();
				license.url = l.@url.toString();
				
				licenses.push( license );	
			}
			
			return licenses;
		}
		
		/**
		 * Converts a note XML object into a Note instance
		 */
		internal static function parsePhotoNote( xml:XML ):PhotoNote {
			var photoNote:PhotoNote = new PhotoNote();
			
			photoNote.id = xml.note.@id.toString();
			
			return photoNote;
		}
		
		/**
		 * Converts an uploader ticket list XML object into an Array of UploadTicket instances
		 */
		internal static function parseUploadTicketList( xml:XML ):Array {
			var uploadTickets:Array = new Array();
			
			for each ( var t:XML in xml.uploader.ticket ) {
				var uploadTicket:UploadTicket = new UploadTicket();
				uploadTicket.id = t.@id.toString();
				uploadTicket.photoId = t.@photoid.toString();
				uploadTicket.isComplete = t.@complete.toString() == "1";
				uploadTicket.uploadFailed = t.@complete.toString() == "2";
				uploadTicket.isInvalid = t.@invalid.toString() == "1";
				
				uploadTickets.push( uploadTicket );	
			}
			
			return uploadTickets;
		}
		
		/**
		 * Converts a photo set XML object into a PhotoSet instance
		 */
		internal static function parsePhotoSet( xml:XML ):PhotoSet {
			var photoSet:PhotoSet = new PhotoSet();
			
			photoSet.id = xml.photoset.@id.toString();
			photoSet.url = xml.photoset.@url.toString();
			photoSet.ownerId = xml.photoset.@owner.toString();
			photoSet.primaryPhotoId = xml.photoset.@primary.toString();
			if ( xml.photoset.@photos.toString() ) {
				photoSet.photoCount = parseInt( xml.photoset.@photos.toString() );	
			}
			photoSet.title = xml.photoset.title.toString();
			photoSet.description = xml.photoset.description.toString();
			photoSet.secret = xml.photoset.@secret.toString();
			if ( xml.photoset.@server.toString() ) {
				photoSet.server = parseInt( xml.photoset.@server.toString() );	
			}
			
			for each ( var p:XML in xml.photoset.photo ) {
				var photo:Photo = new Photo();
				photo.id = p.@id.toString();
				photo.secret = p.@secret.toString();
				photo.title = p.@title.toString();
				photo.server = parseInt( p.@server );
				photo.farmId = parseInt(p.@farm);
				
				photoSet.photos.push( photo );	
			}
			
			return photoSet;
		}
		
		/**
		 * Converts a photo set list XML object into a PhotoSet instance
		 */
		internal static function parsePhotoSetList( xml:XML ):Array {
			var photoSets:Array = new Array();
			
			for each ( var s:XML in xml.photosets.photoset ) {
				var photoSet:PhotoSet = new PhotoSet();
				photoSet.id = s.@id.toString();
				photoSet.url = s.@url.toString();
				photoSet.ownerId = s.@ownerid.toString();
				photoSet.primaryPhotoId = s.@primary.toString();
				photoSet.photoCount = parseInt( s.@photos.toString() );	
				photoSet.secret = s.@secret.toString();
				photoSet.server = parseInt( s.@server.toString() );	
				photoSet.title = s.title.toString();
				photoSet.description = s.description.toString();
				
				photoSets.push( photoSet );	
			}
			
			return photoSets;
		}
		
		/**
		 * Converts a tag list XML object into a User instance
		 */
		internal static function parseUserTags( xml:XML ):User {
			var user:User = new User();
			
			user.nsid = xml.who.@id.toString();
			for each ( var t:XML in xml.who.tags.tag ) {
				var photoTag:PhotoTag = new PhotoTag();
				photoTag.raw = t.toString();
				photoTag.tag = t.toString();
				if ( t.@count.toString() ) {
					photoTag.count = parseInt( t.@count	);
				}
				user.tags.push( photoTag );	
			}
			
			return user;	
		}
		
		/**
		 * Converts a tag list XML object into an Array of PhotoTag instances
		 */
		internal static function parseTagList( xml:XML ):Array {
			var tags:Array = new Array();
			
			for each ( var t:XML in xml.tags.tag ) {
				var photoTag:PhotoTag = new PhotoTag();
				photoTag.raw = t.toString();
				photoTag.tag = t.toString();
				tags.push( photoTag );	
			}
			
			return tags;
		}

	}
	
}