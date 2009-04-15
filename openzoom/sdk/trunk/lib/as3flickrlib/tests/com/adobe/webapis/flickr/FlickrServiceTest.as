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

	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import com.adobe.webapis.flickr.*;
	import com.adobe.webapis.flickr.events.*;
	import com.adobe.webapis.flickr.methodgroups.MethodGroupHelper;
	import flexunit.framework.Test;
	
	public class FlickrServiceTest extends TestCase {
		
		private const CALL_TIMEOUT:int = 10000;
		
		/**
		*	You need to provide your own API keys here in order for the
		*	test to run.
		*
		*	http://www.flickr.com/services/api/auth.howto.desktop.html
		*/		
		public static var API_KEY:String = "<APP KEY>";
		public static var SECRET:String = "<SHARED SECRET>";
		
	    public function FlickrServiceTest( methodName:String ) {
			super( methodName );
        }
	
		public static function suite():TestSuite {
			var ts:TestSuite = new TestSuite();
			
			ts.addTest( Test( new FlickrServiceTest("testAPIKey") ) );
			ts.addTest( Test( new FlickrServiceTest("testSecret") ) );
			
			//*********************************************************
			// Test the "Auth" method group
			//*********************************************************
			// Not tested - need to have a valid token to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testAuthCheckToken") ) );
			ts.addTest( Test( new FlickrServiceTest("testAuthGetFrob") ) );
			// Not tested - need to have a valid frob to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testAuthGetToken") ) );
			
			//*********************************************************
			// Test the "Blogs" method group
			//*********************************************************
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testBlogsGetList") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testBlogsPostPhoto") ) );
			
			//*********************************************************
			// Test the "Contacts" method group
			//*********************************************************
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testContactsGetList") ) );
			ts.addTest( Test( new FlickrServiceTest("testContactsGetPublicList") ) );
			
			//*********************************************************
			// Test the "Favorites" method group
			//*********************************************************
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testFavoritesAdd") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testFavoritesGetList") ) );
			ts.addTest( Test( new FlickrServiceTest("testFavoritesGetPublicList") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testFavoritesRemove") ) );
			
			//*********************************************************
			// Test the "Groups" method group
			//*********************************************************
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testGroupsBrowse") ) );
			ts.addTest( Test( new FlickrServiceTest("testGroupsGetInfo") ) );
			ts.addTest( Test( new FlickrServiceTest("testGroupsSearch") ) );
			
			//*********************************************************
			// Test the "Pools" method group
			//*********************************************************
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testGroupsPoolsAdd") ) );
			ts.addTest( Test( new FlickrServiceTest("testGroupsPoolsGetContext") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testGroupsPoolsGetGroups") ) );
			ts.addTest( Test( new FlickrServiceTest("testGroupsPoolsGetPhotos") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testGroupsPoolsRemove") ) );
			
			//*********************************************************
			// Test the "People" method group
			//*********************************************************
			ts.addTest( Test( new FlickrServiceTest("testPeopleFindByEmail") ) );
			ts.addTest( Test( new FlickrServiceTest("testPeopleFindByUsername") ) );
			ts.addTest( Test( new FlickrServiceTest("testPeopleGetInfo") ) );
			ts.addTest( Test( new FlickrServiceTest("testPeopleGetPublicGroups") ) );
			ts.addTest( Test( new FlickrServiceTest("testPeopleGetPublicPhotos") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPeopleGetUploadStatus") ) );
			
			//*********************************************************
			// Test the "Photos" method group
			//*********************************************************
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotosAddTags") ) );
			ts.addTest( Test( new FlickrServiceTest("testPhotosGetAllContexts") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotosGetContactsPhotos") ) );
			ts.addTest( Test( new FlickrServiceTest("testPhotosGetContactsPublicPhotos") ) );
			ts.addTest( Test( new FlickrServiceTest("testPhotosGetContext") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotosGetCounts") ) );
			ts.addTest( Test( new FlickrServiceTest("testPhotosGetExif") ) );
			ts.addTest( Test( new FlickrServiceTest("testPhotosGetInfo") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotosGetNotInSet") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotosGetPerms") ) );
			ts.addTest( Test( new FlickrServiceTest("testPhotosGetRecent") ) );
			ts.addTest( Test( new FlickrServiceTest("testPhotosGetSizes") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotosGetUntagged") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotosRemoveTag") ) );
			ts.addTest( Test( new FlickrServiceTest("testPhotosSearch") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotosSetDates") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotosSetMeta") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotosSetPerms") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotosSetTags") ) );
			
			//*********************************************************
			// Test the "Licenses" method group
			//*********************************************************
			ts.addTest( Test( new FlickrServiceTest("testPhotosLicensesGetInfo") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotosLicensesSetLicense") ) );
			
			//*********************************************************
			// Test the "Notes" method group
			//*********************************************************
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotosNotesAdd") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotosNotesDelete") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotosNotesEdit") ) );
			
			//*********************************************************
			// Test the "Transform" method group
			//*********************************************************
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotosTransformRotate") ) );
			
			//*********************************************************
			// Test the "Upload" method group
			//*********************************************************
			ts.addTest( Test( new FlickrServiceTest("testPhotosUploadCheckTickets") ) );
			
			//*********************************************************
			// Test the "PhotoSets" method group
			//*********************************************************
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotoSetsAddPhoto") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotoSetsCreate") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotoSetsDelete") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotoSetsEditMeta") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotoSetsEditPhotos") ) );
			ts.addTest( Test( new FlickrServiceTest("testPhotoSetsGetContext") ) );
			ts.addTest( Test( new FlickrServiceTest("testPhotoSetsGetInfo") ) );
			ts.addTest( Test( new FlickrServiceTest("testPhotoSetsGetList") ) );
			ts.addTest( Test( new FlickrServiceTest("testPhotoSetsGetPhotos") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotoSetsOrderSets") ) );
			// Not tested - need to be authenticated to return successful result
			//ts.addTest( Test( new FlickrServiceTest("testPhotoSetsRemovePhoto") ) );
			
			//*********************************************************
			// Test the "Tags" method group
			//*********************************************************
			ts.addTest( Test( new FlickrServiceTest("testTagsGetListPhoto") ) );
			ts.addTest( Test( new FlickrServiceTest("testTagsGetListUser") ) );
			ts.addTest( Test( new FlickrServiceTest("testTagsGetListUserPopular") ) );
			ts.addTest( Test( new FlickrServiceTest("testTagsGetRelated") ) );
			
			//*********************************************************
			// Test the "Test" method group
			//*********************************************************
			ts.addTest( Test( new FlickrServiceTest("testTestEcho") ) );
			ts.addTest( Test( new FlickrServiceTest("testTestLogin") ) );
			
			//*********************************************************
			// Test the "Urls" method group
			//*********************************************************
			ts.addTest( Test( new FlickrServiceTest("testUrlsGetGroup") ) );
			ts.addTest( Test( new FlickrServiceTest("testUrlsGetUserPhotos") ) );
			ts.addTest( Test( new FlickrServiceTest("testUrlsGetUserProfile") ) );
			ts.addTest( Test( new FlickrServiceTest("testUrlsLookupGroup") ) );
			ts.addTest( Test( new FlickrServiceTest("testUrlsLookupUser") ) );
			
			//*********************************************************
			// Test the "Interestingness" method group
			//*********************************************************
			ts.addTest( Test( new FlickrServiceTest("testInterestingnessGetList") ) );
			ts.addTest( Test( new FlickrServiceTest("testInterestingnessGetListWithDate") ) );

			return ts;
		}
		
		public function testAPIKey():void {
			var service:FlickrService = new FlickrService( API_KEY );
		
			assertTrue( "service.api_key == API_KEY", service.api_key == API_KEY );
		}
		
		public function testSecret():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.secret = SECRET;
			assertTrue( "service.secret == SECRET", service.secret == SECRET );
		}
		
		//**************************************************************
		//
		// Tests for the "Auth" Method Group
		//
		//**************************************************************
		
		public function testAuthGetFrob():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.secret = SECRET;
			service.addEventListener( FlickrResultEvent.AUTH_GET_FROB, 
									  addAsync( onAuthGetFrob, CALL_TIMEOUT ) );
			service.auth.getFrob();
		}
		
		private function onAuthGetFrob( event:FlickrResultEvent ):void {
			assertTrue("event.success == true", event.success );
			
			var frob:String = String( event.data.frob );
			assertTrue("event data is string with length", frob.length > 0 ); 
		}
		
		//**************************************************************
		//
		// Tests for the "Blogs" Method Group
		//
		//**************************************************************
		
		//**************************************************************
		//
		// Tests for the "Contacts" Method Group
		//
		//**************************************************************
		
		public function testContactsGetPublicList():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.CONTACTS_GET_PUBLIC_LIST, 
									  addAsync( onContactsGetPublicList, CALL_TIMEOUT ) );
			service.contacts.getPublicList( "82511024@N00" );
		}
		
		private function onContactsGetPublicList( event:FlickrResultEvent ):void {
			var contacts:Array = event.data.contacts;
			
			assertTrue( "contacts length > 0", contacts.length > 0 );
			assertTrue( "contacts[0] username populated", contacts[0].username.length > 0 );
		}
		
		//**************************************************************
		//
		// Tests for the "Favorites" Method Group
		//
		//**************************************************************
		
		public function testFavoritesGetPublicList():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.FAVORITES_GET_PUBLIC_LIST, 
									  addAsync( onFavoritesGetPublicList, CALL_TIMEOUT ) );
			service.favorites.getPublicList( "82511024@N00" );
		}
		
		private function onFavoritesGetPublicList( event:FlickrResultEvent ):void {
			var photos:PagedPhotoList = event.data.photos;
			
			assertTrue( "page == 1", photos.page == 1 );
			assertTrue( "photo length > 0", photos.photos.length > 0 );
			assertTrue( "secret is present", photos.photos[0].secret.length > 0 );
		}
		
		//*********************************************************
		//
		// Test the "Groups" method group
		//
		//*********************************************************
		
		public function testGroupsGetInfo():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.GROUPS_GET_INFO,
									  addAsync( onGroupsGetInfo, CALL_TIMEOUT ) );
			service.groups.getInfo( "30691243@N00" );
		}
		
		private function onGroupsGetInfo( event:FlickrResultEvent ):void {
			var group:Group = event.data.group;
			
			assertTrue( "nsid populated", group.nsid.length > 0 );
			assertTrue( "description has length", group.description.length > 0 );
			assertTrue( "name has length", group.name.length > 0 );
			assertTrue( "members is >= 0", group.members >= 0 );
			assertTrue( "privacy is >= 0", group.privacy >= 0 );
		}
		
		public function testGroupsSearch():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.GROUPS_SEARCH,
									  addAsync( onGroupsSearch, CALL_TIMEOUT ) );
			service.groups.search( "macromedia" );
		}
		
		private function onGroupsSearch( event:FlickrResultEvent ):void {
			var pagedGroupList:PagedGroupList = event.data.groups;
			
			assertTrue( "on page 1", pagedGroupList.page == 1 );
			assertTrue( "pages >= 1", pagedGroupList.pages >= 1 );
			assertTrue( "perPage is 100", pagedGroupList.perPage == 100 );
			assertTrue( "total >= 1", pagedGroupList.total >= 1 );
			assertTrue( "groups has content", pagedGroupList.groups[0] != null );
		}
		
		//*********************************************************
		//
		// Test the "Pools" method group
		//
		//*********************************************************
		
		public function testGroupsPoolsGetContext():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.GROUPS_POOLS_GET_CONTEXT,
									  addAsync( onGroupsPoolsGetContext, CALL_TIMEOUT ) );
			service.groups.pools.getContext( "69878677", "62045142@N00" );
		}
		
		private function onGroupsPoolsGetContext( event:FlickrResultEvent ):void {
			var context:Array = event.data.context;
			
			assertTrue( "context length of 2", context.length == 2 );
			assertTrue( "prevPhoto title", context[0].title.length >= 1 );
			assertTrue( "prevPhoto id", context[0].id.length >= 1 );
			assertTrue( "prevPhoto url", context[0].url.length >= 1 );
			assertTrue( "prevPhoto secret", context[0].secret.length >= 1 );
			assertTrue( "nextPhoto title", context[1].title.length >= 1 );
			assertTrue( "nextPhoto id", context[1].id.length >= 1 );
			assertTrue( "nextPhoto url", context[1].url.length >= 1 );
			assertTrue( "nextPhoto secret", context[1].secret.length >= 1 );
		}
		
		public function testGroupsPoolsGetPhotos():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.GROUPS_POOLS_GET_PHOTOS,
									  addAsync( onGroupsPoolsGetPhotos, CALL_TIMEOUT ) );
			service.groups.pools.getPhotos( "62045142@N00" );
		}
		
		private function onGroupsPoolsGetPhotos( event:FlickrResultEvent ):void {
			var photoList:PagedPhotoList = event.data.photos;
			
			assertTrue( "page == 1", photoList.page == 1 );
			assertTrue( "photo length > 0", photoList.photos.length > 0 );
			assertTrue( "secret is present on a photo", photoList.photos[0].secret.length > 0 );
		}
		
		//*********************************************************
		//
		// Test the "People" method group
		//
		//*********************************************************
		
		public function testPeopleFindByEmail():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.PEOPLE_FIND_BY_EMAIL,
									  addAsync( onPeopleFindByEmail, CALL_TIMEOUT ) );
			service.people.findByEmail( "ddura@macromedia.com" );
		}
		
		private function onPeopleFindByEmail( event:FlickrResultEvent ):void {
			var user:User = event.data.user;
			
			assertTrue( "nsid present", user.nsid.length >= 0 );
			assertTrue( "username present", user.username.length >= 0 );
		}
		
		public function testPeopleFindByUsername():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.PEOPLE_FIND_BY_USERNAME,
									  addAsync( onPeopleFindByUsername, CALL_TIMEOUT ) );
			service.people.findByUsername( "darronschall" );
		}
		
		private function onPeopleFindByUsername( event:FlickrResultEvent ):void {
			var user:User = event.data.user;
			
			assertTrue( "nsid present", user.nsid.length >= 0 );
			assertTrue( "username present", user.username.length >= 0 );
		}
		
		public function testPeopleGetInfo():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.PEOPLE_GET_INFO,
									  addAsync( onPeopleGetInfo, CALL_TIMEOUT ) );
			service.people.getInfo( "28074258@N00" );
		}
		
		private function onPeopleGetInfo( event:FlickrResultEvent ):void {
			var user:User = event.data.user;
			
			assertTrue( "user not null", user != null );
			assertTrue( "nsid present", user.nsid.length >= 1 );
			assertTrue( "isAdmin false", user.isAdmin == false );
			assertTrue( "isPro true", user.isPro == true );
			assertTrue( "iconServer present", user.iconServer >= 0 );
			assertTrue( "fullname present", user.fullname.length >= 1 );
			assertTrue( "mbox sha1 sum present", user.mboxSha1Sum.length >= 1 );
			assertTrue( "location present", user.location.length >= 1 );
			assertTrue( "photoUrl present", user.photoUrl.length >= 1 );
			assertTrue( "profileUrl present", user.profileUrl.length >= 1 );
			assertTrue( "first date taken present", user.firstPhotoTakenDate != null );
			assertTrue( "first date upload present", user.firstPhotoUploadDate != null );
			assertTrue( "photo count preset", user.photoCount >= 1 );
		}
		
		public function testPeopleGetPublicGroups():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.PEOPLE_GET_PUBLIC_GROUPS,
									  addAsync( onPeopleGetPublicGroups, CALL_TIMEOUT ) );
			service.people.getPublicGroups( "82511024@N00" );
		}
		
		private function onPeopleGetPublicGroups( event:FlickrResultEvent ):void {
			var groups:Array = event.data.groups;
			
			assertTrue( "groups length >= 1", groups.length >= 1 );
			assertTrue( "group[0] name length", groups[0].name.length >= 1 );
			assertTrue( "group[0] nsid length", groups[0].nsid.length >= 1 );
		}
		
		public function testPeopleGetPublicPhotos():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.PEOPLE_GET_PUBLIC_PHOTOS,
									  addAsync( onPeopleGetPublicPhotos, CALL_TIMEOUT ) );
			service.people.getPublicPhotos( "82511024@N00" );
		}
		
		private function onPeopleGetPublicPhotos( event:FlickrResultEvent ):void {
			var photoList:PagedPhotoList = event.data.photos;
			
			assertTrue( "page == 1", photoList.page == 1 );
			assertTrue( "perPage == 100", photoList.perPage == 100 );
			assertTrue( "photo length > 0", photoList.photos.length > 0 );
			assertTrue( "secret is present on a photo", photoList.photos[0].secret.length > 0 );
			assertTrue( "photo total > 0", photoList.total > 0 );
		}
		
		//*********************************************************
		//
		// Test the "Photos" method group
		//
		//*********************************************************
		
		public function testPhotosGetAllContexts():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.PHOTOS_GET_ALL_CONTEXTS,
									  addAsync( onPhotosGetAllContexts, CALL_TIMEOUT ) );
			service.photos.getAllContexts( "69999323" );
		}
		
		private function onPhotosGetAllContexts( event:FlickrResultEvent ):void {
			var photoContext:PhotoContext = event.data.photoContext;
			
			assertTrue( "sets length", photoContext.sets.length >= 1 );
			assertTrue( "sets[0] id", photoContext.sets[0].id.length >= 1 );
			assertTrue( "sets[0] title", photoContext.sets[0].title.length >= 1 );
			assertTrue( "pools length", photoContext.pools.length >= 1 );
			assertTrue( "pools[0] id", photoContext.pools[0].id.length >= 1 );
			assertTrue( "pools[0] title", photoContext.pools[0].title.length >= 1 );
		}
		
		public function testPhotosGetContactsPublicPhotos():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.PHOTOS_GET_CONTACTS_PUBLIC_PHOTOS,
									  addAsync( onPhotosGetContactsPublicPhotos, CALL_TIMEOUT ) );
			service.photos.getContactsPublicPhotos( "82511024@N00" );
		}
		
		private function onPhotosGetContactsPublicPhotos( event:FlickrResultEvent ):void {
			var photos:Array = event.data.photos;
			
			assertTrue( "photos length > 0", photos.length > 0 );
			assertTrue( "photos[0] id", photos[0].id.length > 0 );
			assertTrue( "photos[0] title", photos[0].title.length > 0 );
			assertTrue( "photos[0] secret", photos[0].secret.length > 0 );
			assertTrue( "photos[0] ownerId", photos[0].ownerId.length > 0 );
			assertTrue( "photos[0] ownerName", photos[0].ownerName.length > 0 );
		}
		
		public function testPhotosGetContext():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.PHOTOS_GET_CONTEXT,
									  addAsync( onPhotosGetContext, CALL_TIMEOUT ) );
			service.photos.getContext( "69999323" );
		}
		
		private function onPhotosGetContext( event:FlickrResultEvent ):void {
			var context:Array = event.data.context;
			
			assertTrue( "context length of 2", context.length == 2 );
			assertTrue( "prevPhoto title", context[0].title.length >= 1 );
			assertTrue( "prevPhoto id", context[0].id.length >= 1 );
			assertTrue( "prevPhoto url", context[0].url.length >= 1 );
			assertTrue( "prevPhoto secret", context[0].secret.length >= 1 );
			assertTrue( "nextPhoto title", context[1].title.length >= 1 );
			assertTrue( "nextPhoto id", context[1].id.length >= 1 );
			assertTrue( "nextPhoto url", context[1].url.length >= 1 );
			assertTrue( "nextPhoto secret", context[1].secret.length >= 1 );
		}
		
		public function testPhotosGetExif():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.PHOTOS_GET_EXIF,
									  addAsync( onPhotosGetExif, CALL_TIMEOUT ) );
			service.photos.getExif( "69999323" );
		}
		
		private function onPhotosGetExif( event:FlickrResultEvent ):void {
			var photo:Photo = event.data.photo;
			
			assertTrue( "photo id", photo.id == "69999323" );
			assertTrue( "photo secret", photo.secret.length >= 1 );
			assertTrue( "photo server", photo.server >= 1 );
			assertTrue( "photo exifs", photo.exifs.length > 0 );
			assertTrue( "photo exifs[0].tag", photo.exifs[0].tag == 629 );
			assertTrue( "photo exifs[0].tagspace", photo.exifs[0].tagspace == "IPTC" );
			assertTrue( "photo exifs[0].tagspaceId", photo.exifs[0].tagspaceId == 5 );
			assertTrue( "photo exifs[0].raw", photo.exifs[0].raw.length > 0 );
			assertTrue( "photo exifs[0].label", photo.exifs[0].label == "Tag::IPTC::0x0275" );
		}
		
		public function testPhotosGetInfo():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.PHOTOS_GET_INFO,
									  addAsync( onPhotosGetInfo, CALL_TIMEOUT ) );
			service.photos.getInfo( "69999323" );
		}
		
		private function onPhotosGetInfo( event:FlickrResultEvent ):void {
			var photo:Photo = event.data.photo;

			assertTrue( "photo id", photo.id == "69999323" );
			assertTrue( "photo title", photo.title.length > 0 );
			assertTrue( "photo description", photo.description.length > 0 );
			assertTrue( "photo tags", photo.tags.length > 0 );
			assertTrue( "photo tags[0].authorId", photo.tags[0].authorId == "84045295@N00" );
			assertTrue( "photo tags[0].id", photo.tags[0].id == "1828118-69999323-282" );
			assertTrue( "photo tags[0].raw", photo.tags[0].raw == "sky" );
			assertTrue( "photo tags[0].tag", photo.tags[0].tag == "sky" );
			assertTrue( "photo urls", photo.urls.length > 0 );
			assertTrue( "photo urls[0].type", photo.urls[0].type == "photopage" );
			assertTrue( "photo urls[0].url", photo.urls[0].url == "http://www.flickr.com/photos/net-adept/69999323/" );
		}

		public function testPhotosGetRecent():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.PHOTOS_GET_RECENT,
									  addAsync( onPhotosGetRecent, CALL_TIMEOUT ) );
			service.photos.getRecent( "license,date_upload,date_taken,owner_name,icon_server,original_format" );
		}
		
		private function onPhotosGetRecent( event:FlickrResultEvent ):void {
			var photoList:PagedPhotoList = event.data.photos;
			
			assertTrue( "page == 1", photoList.page == 1 );
			assertTrue( "perPage == 100", photoList.perPage == 100 );
			assertTrue( "photo length > 0", photoList.photos.length > 0 );
			assertTrue( "secret is present on a photo", photoList.photos[0].secret.length > 0 );
			assertTrue( "photo total > 0", photoList.total > 0 );
		}
		
		public function testPhotosGetSizes():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.PHOTOS_GET_SIZES,
									  addAsync( onPhotosGetSizes, CALL_TIMEOUT ) );
			service.photos.getSizes( "38059757" );
		}
		
		private function onPhotosGetSizes( event:FlickrResultEvent ):void {
			var photoSizes:Array = event.data.photoSizes;
			
			assertTrue( "photoSizes not null", photoSizes != null );
			assertTrue( "photoSizes length", photoSizes.length > 0 );
			assertTrue( "photoSizes[0].label", photoSizes[0].label.length > 0 );
			assertTrue( "photoSizes[0].width", photoSizes[0].width > 0 );
			assertTrue( "photoSizes[0].height", photoSizes[0].height > 0 );
			assertTrue( "photoSizes[0].source", photoSizes[0].source.length > 0 );
			assertTrue( "photoSizes[0].url", photoSizes[0].url.length > 0 );
		}
		
		public function testPhotosSearch():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.PHOTOS_SEARCH,
									  addAsync( onPhotosSearch, CALL_TIMEOUT ) );
			service.photos.search( "", "macromedia" );
		}
		
		private function onPhotosSearch( event:FlickrResultEvent ):void {
			var photoList:PagedPhotoList = event.data.photos;
			
			assertTrue( "page == 1", photoList.page == 1 );
			assertTrue( "perPage == 100", photoList.perPage == 100 );
			assertTrue( "photo length > 0", photoList.photos.length > 0 );
			assertTrue( "secret is present on a photo", photoList.photos[0].secret.length > 0 );
			assertTrue( "photo total > 0", photoList.total > 0 );
		}
		
		//**************************************************************
		//
		// Tests for the "Licenses" Method Group
		//
		//**************************************************************
		
		public function testPhotosLicensesGetInfo():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.PHOTOS_LICENSES_GET_INFO,
									  addAsync( onPhotosLicensesGetInfo, CALL_TIMEOUT ) );
			service.photos.licenses.getInfo();
		}
		
		private function onPhotosLicensesGetInfo( event:FlickrResultEvent ):void {
			var licenses:Array = event.data.licenses;
			
			assertTrue( "licenses not null", licenses != null );
			assertTrue( "licenses length", licenses.length > 0 );
			assertTrue( "licenses[0].id", licenses[0].id >= 0 );
			assertTrue( "licenses[0].name", licenses[0].name.length > 0 );
			assertTrue( "licenses[0].url", licenses[0].url.length == 0 );
			assertTrue( "licenses[1].url", licenses[1].url.length > 0 );
		}
		
		//*********************************************************
		//
		// Test the "Notes" method group
		//
		//*********************************************************
		
		// Nothing to test
		
		//*********************************************************
		//
		// Test the "Transform" method group
		//
		//*********************************************************
		
		// Nothing to test
		
		
		//*********************************************************
		//
		// Test the "Upload" method group
		//
		//*********************************************************
		
		public function testPhotosUploadCheckTickets():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.PHOTOS_UPLOAD_CHECK_TICKETS, 
									  addAsync( onPhotosUploadCheckTickets, CALL_TIMEOUT ) );
			service.photos.upload.checkTickets( [1, 2] );
		}
		
		private function onPhotosUploadCheckTickets( event:FlickrResultEvent ):void {
			var uploadTickets:Array = event.data.uploadTickets;
			
			assertTrue( "uploadTickets not null", uploadTickets != null );
			assertTrue( "uploadTickets length", uploadTickets.length == 2 );
			assertTrue( "uploadTickets[0].id", uploadTickets[0].id == "1" );
			assertTrue( "uploadTickets[0].isInvalid", uploadTickets[0].isInvalid == true );
		}
		
		//*********************************************************
		//
		// Test the "PhotoSets" method group
		//
		//*********************************************************
		
		public function testPhotoSetsGetContext():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.PHOTOSETS_GET_CONTEXT, 
									  addAsync( onPhotoSetsGetContext, CALL_TIMEOUT ) );
			service.photosets.getContext( "53537944", "838083" );
		}
		
		private function onPhotoSetsGetContext( event:FlickrResultEvent ):void {
			var context:Array = event.data.context;
			
			assertTrue( "context length of 2", context.length == 2 );
			assertTrue( "prevPhoto title", context[0].title.length >= 1 );
			assertTrue( "prevPhoto id", context[0].id.length >= 1 );
			assertTrue( "prevPhoto url", context[0].url.length >= 1 );
			assertTrue( "prevPhoto secret", context[0].secret.length >= 1 );
			assertTrue( "nextPhoto title", context[1].title.length >= 1 );
			assertTrue( "nextPhoto id", context[1].id.length >= 1 );
			assertTrue( "nextPhoto url", context[1].url.length >= 1 );
			assertTrue( "nextPhoto secret", context[1].secret.length >= 1 );
		}
		
		public function testPhotoSetsGetInfo():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.PHOTOSETS_GET_INFO, 
									  addAsync( onPhotoSetsGetInfo, CALL_TIMEOUT ) );
			service.photosets.getInfo( "838083" );
		}
		
		private function onPhotoSetsGetInfo( event:FlickrResultEvent ):void {
			var photoSet:PhotoSet = event.data.photoSet;
			
			assertTrue( "photoSet not null", photoSet != null );
			assertTrue( "photoSet.id", photoSet.id == "838083" );
			assertTrue( "photoSet.title", photoSet.title.length > 0 );
			assertTrue( "photoSet.description", photoSet.description.length > 0 );
			assertTrue( "photoSet.primaryPhotoId", photoSet.primaryPhotoId.length > 0 );
			assertTrue( "photoSet.ownerId", photoSet.ownerId.length > 0 );
			assertTrue( "photoSet.photoCount", photoSet.photoCount > 0 );
		}
		
		public function testPhotoSetsGetList():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.PHOTOSETS_GET_LIST, 
									  addAsync( onPhotoSetsGetList, CALL_TIMEOUT ) );
			service.photosets.getList( "39443901262@N01" );
		}
		
		private function onPhotoSetsGetList( event:FlickrResultEvent ):void {
			var photoSets:Array = event.data.photoSets;
			
			assertTrue( "photoSets not null", photoSets != null );
			assertTrue( "photoSets[0].id", photoSets[0].id.length > 0 );
			assertTrue( "photoSets[0].title", photoSets[0].title.length > 0 );
			assertTrue( "photoSets[0].description", photoSets[0].description.length >= 0 );
			assertTrue( "photoSets[0].primaryPhotoId", photoSets[0].primaryPhotoId.length > 0 );
			assertTrue( "photoSets[0].secret", photoSets[0].secret.length > 0 );
			assertTrue( "photoSets[0].server", photoSets[0].server > 0 );
			assertTrue( "photoSets[0].photoCount", photoSets[0].photoCount >= 0 );
		}
		
		public function testPhotoSetsGetPhotos():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.PHOTOSETS_GET_PHOTOS, 
									  addAsync( onPhotoSetsGetPhotos, CALL_TIMEOUT ) );
			service.photosets.getPhotos( "838083" );
		}
		
		private function onPhotoSetsGetPhotos( event:FlickrResultEvent ):void {
			var photoSet:PhotoSet = event.data.photoSet;
			
			assertTrue( "photoSet not null", photoSet != null );
			assertTrue( "photoSet.id", photoSet.id == "838083" );
			assertTrue( "photoSet.primaryPhotoId", photoSet.primaryPhotoId.length > 0 );
			assertTrue( "photoSet.photos[0].id", photoSet.photos[0].id.length > 0 );
			assertTrue( "photoSet.photos[0].title", photoSet.photos[0].title.length > 0 );
			assertTrue( "photoSet.photos[0].secret", photoSet.photos[0].secret.length > 0 );
		}
		
		//*********************************************************
		//
		// Test the "Tags" method group
		//
		//*********************************************************
		
		public function testTagsGetListPhoto():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.TAGS_GET_LIST_PHOTO, 
									  addAsync( onTagsGetListPhoto, CALL_TIMEOUT ) );
			service.tags.getListPhoto( "53537944" );
		}
		
		private function onTagsGetListPhoto( event:FlickrResultEvent ):void {
			var photo:Photo = event.data.photo;
			
			assertTrue( "photo not null", photo != null );
			assertTrue( "tags length", photo.tags.length > 0 );
			assertTrue( "tags[0].raw", photo.tags[0].raw.length > 0 );
		}
		
		public function testTagsGetListUser():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.TAGS_GET_LIST_USER, 
									  addAsync( onTagsGetListUser, CALL_TIMEOUT ) );
			service.tags.getListUser( "39443901262@N01" );
		}
		
		private function onTagsGetListUser( event:FlickrResultEvent ):void {
			var user:User = event.data.user;
			
			assertTrue( "user not null", user != null );
			assertTrue( "tags populated", user.tags.length > 0 );
			assertTrue( "tags[0] populated", user.tags[0].raw.length > 0 );
		}
		
		public function testTagsGetListUserPopular():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.TAGS_GET_LIST_USER_POPULAR, 
									  addAsync( onTagsGetListUserPopular, CALL_TIMEOUT ) );
			service.tags.getListUserPopular( "39443901262@N01" );
		}
		
		private function onTagsGetListUserPopular( event:FlickrResultEvent ):void {
			var user:User = event.data.user;
			
			assertTrue( "user not null", user != null );
			assertTrue( "tags populated", user.tags.length > 0 );
			assertTrue( "tags[0] populated", user.tags[0].raw.length > 0 );
		}
		
		public function testTagsGetRelated():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.TAGS_GET_RELATED, 
									  addAsync( onTagsGetRelated, CALL_TIMEOUT ) );
			service.tags.getRelated( "macromedia" );
		}
		
		private function onTagsGetRelated( event:FlickrResultEvent ):void {
			var tags:Array = event.data.tags;
			
			assertTrue( "tags not null", tags != null );
			assertTrue( "tags populated", tags.length > 0 );
			assertTrue( "tags[0].raw populated", tags[0].raw.length > 0 );
		}
		
		//**************************************************************
		//
		// Tests for the "Test" Method Group
		//
		//**************************************************************
		
		public function testTestEcho():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.TEST_ECHO, 
									  addAsync( onTestEcho, CALL_TIMEOUT ) );
			service.test.echo( "test" );
		}
	
		private function onTestEcho( event:FlickrResultEvent ):void {
			assertTrue("event.success == true", event.success );
			assertTrue("event.data.method == 'flickr.test.echo'", event.data.method = "flickr.test.echo");
			assertTrue("event.data.param0 == 'test'", event.data.param0 == "test");
		}
		
		public function testTestLogin():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.TEST_LOGIN, 
									  addAsync( onTestLogin, CALL_TIMEOUT ) );
			service.test.login();
		}
		
		private function onTestLogin( event:FlickrResultEvent ):void {
			// Because we're not logged in, we should get an insufficient permission
			assertTrue("event.success == false", event.success == false );
			
			// Test the the error was constructed correctly
			var e:FlickrError = event.data.error;
			assertTrue( "e.errorCode == insufficient permission", e.errorCode == FlickrError.INSUFFICIENT_PERMISSIONS );
			assertTrue( "testing for correct error message", e.errorMessage == "Insufficient permissions. Method requires read privileges; none granted." );
			
		}
		
		//**************************************************************
		//
		// Tests for the "Urls" Method Group
		//
		//**************************************************************
		
		public function testUrlsGetGroup():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.URLS_GET_GROUP, 
									  addAsync( onUrlsGetGroup, CALL_TIMEOUT ) );
			service.urls.getGroup( "62045142@N00" );
		}
		
		private function onUrlsGetGroup( event:FlickrResultEvent ):void {
			var group:Group = event.data.group;
			
			assertTrue( "group not null", group != null );
			assertTrue( "group.url", group.url.length > 0 );
			assertTrue( "group.nsid", group.nsid == "62045142@N00" );
		}
		
		public function testUrlsGetUserPhotos():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.URLS_GET_USER_PHOTOS, 
									  addAsync( onUrlsGetUserPhotos, CALL_TIMEOUT ) );
			service.urls.getUserPhotos( "39443901262@N01" );
		}
		
		private function onUrlsGetUserPhotos( event:FlickrResultEvent ):void {
			var user:User = event.data.user;
			
			assertTrue( "user not null", user != null );
			assertTrue( "user.url", user.url.length > 0);
			assertTrue( "user.nsid", user.nsid.length > 0 );
		}
		
		public function testUrlsGetUserProfile():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.URLS_GET_USER_PROFILE, 
									  addAsync( onUrlsGetUserProfile, CALL_TIMEOUT ) );
			service.urls.getUserProfile( "39443901262@N01" );
		}
		
		private function onUrlsGetUserProfile( event:FlickrResultEvent ):void {
			var user:User = event.data.user;
			
			assertTrue( "user not null", user != null );
			assertTrue( "user.url", user.url.length > 0);
			assertTrue( "user.id", user.nsid.length > 0 );
		}
		
		public function testUrlsLookupGroup():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.URLS_LOOKUP_GROUP, 
									  addAsync( onUrlsLookupGroup, CALL_TIMEOUT ) );
			service.urls.lookupGroup( "http://www.flickr.com/groups/picturethemoon/" );
		}
		
		private function onUrlsLookupGroup( event:FlickrResultEvent ):void {
			var group:Group = event.data.group;
			
			assertTrue( "group not null", group != null );
			assertTrue( "group.nsid", group.nsid == "62045142@N00" );
			assertTrue( "group.name", group.name == "Picture the Moon" );
		}
		
		public function testUrlsLookupUser():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.URLS_LOOKUP_USER, 
									  addAsync( onUrlsLookupUser, CALL_TIMEOUT ) );
			service.urls.lookupUser( "http://www.flickr.com/photos/darronschall" );
		}
		
		private function onUrlsLookupUser( event:FlickrResultEvent ):void {
			var user:User = event.data.user;
			
			assertTrue( "user not null", user != null );
			assertTrue( "user.username", user.username == "darronschall" );
			assertTrue( "user.nsid", user.nsid.length > 0 );
		}
		
		//**************************************************************
		//
		// Tests for the "Interestingness" Method Group
		//
		//**************************************************************
		
		public function testInterestingnessGetList():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.INTERESTINGNESS_GET_LIST, 
									  addAsync( onInterestingnessGetList, CALL_TIMEOUT ) );
			service.interestingness.getList();
		}

		public function testInterestingnessGetListWithDate():void {
			var service:FlickrService = new FlickrService( API_KEY );
			service.addEventListener( FlickrResultEvent.INTERESTINGNESS_GET_LIST, 
									  addAsync( onInterestingnessGetList, CALL_TIMEOUT ) );
			var exploreDate:Date = new Date();
			var msPerDay:int = 1000 * 60 * 60 * 24;
			exploreDate.setTime(exploreDate.getTime() - msPerDay);
			service.interestingness.getList(exploreDate);
		}
		
		private function onInterestingnessGetList( event:FlickrResultEvent ):void {
			var photoList:PagedPhotoList = event.data.photos;
			
			assertTrue( "page == 1", photoList.page == 1 );
			assertTrue( "perPage == 100", photoList.perPage == 100 );
			assertTrue( "photo length > 0", photoList.photos.length > 0 );
			assertTrue( "secret is present on a photo", photoList.photos[0].secret.length > 0 );
			assertTrue( "photo total > 0", photoList.total > 0 );
		}
	}
		
}