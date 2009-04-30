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
	import flash.geom.Rectangle;
	import flexunit.framework.Test;
	
	public class ValueObjectTest extends TestCase {
		
	    public function ValueObjectTest( methodName:String ) {
			super( methodName );
        }
	
		public static function suite():TestSuite {
			var ts:TestSuite = new TestSuite();
			
			//**************************************************************
			// Tests for AuthResult
			//**************************************************************
			ts.addTest( Test( new ValueObjectTest("testAuthResultToken") ) );
			ts.addTest( Test( new ValueObjectTest("testAuthResultPerms") ) );
			ts.addTest( Test( new ValueObjectTest("testAuthResultUser") ) );
			
			//**************************************************************
			// Tests for Blog
			//**************************************************************
			ts.addTest( Test( new ValueObjectTest("testBlogId") ) );
			ts.addTest( Test( new ValueObjectTest("testBlogName") ) );
			ts.addTest( Test( new ValueObjectTest("testBlogNeedsPassword") ) );
			ts.addTest( Test( new ValueObjectTest("testBlogUrl") ) );
			
			//**************************************************************
			// Tests for Category
			//**************************************************************
			ts.addTest( Test( new ValueObjectTest("testCategoryId") ) );
			ts.addTest( Test( new ValueObjectTest("testCategoryName") ) );
			ts.addTest( Test( new ValueObjectTest("testCategoryPath") ) );
			ts.addTest( Test( new ValueObjectTest("testCategoryPathIds") ) );
			ts.addTest( Test( new ValueObjectTest("testCategoryCount") ) );
			ts.addTest( Test( new ValueObjectTest("testCategorySubCategories") ) );
			ts.addTest( Test( new ValueObjectTest("testCategoryGroups") ) );
			
			//**************************************************************
			// Tests for Group
			//**************************************************************
			ts.addTest( Test( new ValueObjectTest("testGroupNsid") ) );
			ts.addTest( Test( new ValueObjectTest("testGroupName") ) );
			ts.addTest( Test( new ValueObjectTest("testGroupDescription") ) );
			ts.addTest( Test( new ValueObjectTest("testGroupPrivacy") ) );
			ts.addTest( Test( new ValueObjectTest("testGroupMembers") ) );
			ts.addTest( Test( new ValueObjectTest("testGroupOnline") ) );
			ts.addTest( Test( new ValueObjectTest("testGroupChatNsid") ) );
			ts.addTest( Test( new ValueObjectTest("testGroupInChat") ) );
			ts.addTest( Test( new ValueObjectTest("testGroupIsEighteenPlus") ) );
			ts.addTest( Test( new ValueObjectTest("testGroupIsAdmin") ) );
			ts.addTest( Test( new ValueObjectTest("testGroupPhotos") ) );
			ts.addTest( Test( new ValueObjectTest("testGroupIconServer") ) );
			ts.addTest( Test( new ValueObjectTest("testGroupUrl") ) );
			
			//**************************************************************
			// Tests for License
			//**************************************************************
			ts.addTest( Test( new ValueObjectTest("testLicenseId") ) );
			ts.addTest( Test( new ValueObjectTest("testLicenseName") ) );
			ts.addTest( Test( new ValueObjectTest("testLicenseUrl") ) );
			
			//**************************************************************
			// Tests for PagedGroupList
			//**************************************************************
			ts.addTest( Test( new ValueObjectTest("testPagedGroupListPage") ) );
			ts.addTest( Test( new ValueObjectTest("testPagedGroupListPages") ) );
			ts.addTest( Test( new ValueObjectTest("testPagedGroupListPerPage") ) );
			ts.addTest( Test( new ValueObjectTest("testPagedGroupListTotal") ) );
			ts.addTest( Test( new ValueObjectTest("testPagedGroupListGroups") ) );
			
			//**************************************************************
			// Tests for PagedPhotoList
			//**************************************************************
			ts.addTest( Test( new ValueObjectTest("testPagedPhotoListPage") ) );
			ts.addTest( Test( new ValueObjectTest("testPagedPhotoListPages") ) );
			ts.addTest( Test( new ValueObjectTest("testPagedPhotoListPerPage") ) );
			ts.addTest( Test( new ValueObjectTest("testPagedPhotoListTotal") ) );
			ts.addTest( Test( new ValueObjectTest("testPagedPhotoListPhotos") ) );
				
			//**************************************************************
			// Tests for Photo
			//**************************************************************
			ts.addTest( Test( new ValueObjectTest("testPhotoId") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoOwnerId") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoOwnerName") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoSecret") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoServer") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoIconServer") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoTitle") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoDescription") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoCommentCount") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoIsPublic") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoIsFriend") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoIsFamily") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoLicense") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoDateUploaded") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoDateTaken") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoDateAdded") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoOriginalFormat") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoUrl") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoExifs") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoRotation") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoOwnerRealName") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoOwnerLocation") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoIsFavorite") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoCommentPermission") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoAddMetaPermission") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoCanComment") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoCanAddMeta") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoNotes") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoTags") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoUrls") ) );
			
			//**************************************************************
			// Tests for PhotoContext
			//**************************************************************
			ts.addTest( Test( new ValueObjectTest("testPhotoContextSets") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoContextPools") ) );
			
			//**************************************************************
			// Tests for PhotoCount
			//**************************************************************
			ts.addTest( Test( new ValueObjectTest("testPhotoCountCount") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoCountFromDate") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoCountToDate") ) );
			
			//**************************************************************
			// Tests for PhotoExif
			//**************************************************************
			ts.addTest( Test( new ValueObjectTest("testPhotoExifTagspace") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoExifTagspaceId") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoExifTag") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoExifLabel") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoExifRaw") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoExifClean") ) );
			
			//**************************************************************
			// Tests for PhotoNote
			//**************************************************************
			ts.addTest( Test( new ValueObjectTest("testPhotoNoteId") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoNoteAuthorId") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoNoteAuthorName") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoNoteRectangle") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoNoteNote") ) );
			
			
			//**************************************************************
			// Tests for PhotoPool
			//**************************************************************
			ts.addTest( Test( new ValueObjectTest("testPhotoPoolId") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoPoolTitle") ) );
			
			//**************************************************************
			// Tests for PhotoSet
			//**************************************************************
			ts.addTest( Test( new ValueObjectTest("testPhotoSetId") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoSetTitle") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoSetUrl") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoSetDescription") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoSetPhotoCount") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoSetPrimaryPhotoId") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoSetOwnerId") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoSetSecret") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoSetServer") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoSetPhotos") ) );
			
			//**************************************************************
			// Tests for PhotoSize
			//**************************************************************
			ts.addTest( Test( new ValueObjectTest("testPhotoSizeLabel") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoSizeWidth") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoSizeHeight") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoSizeUrl") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoSizeSource") ) );
			
			//**************************************************************
			// Tests for PhotoTag
			//**************************************************************
			ts.addTest( Test( new ValueObjectTest("testPhotoTagId") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoTagAuthorId") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoTagRaw") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoTagTag") ) );
			ts.addTest( Test( new ValueObjectTest("testPhotoTagCount") ) );
			
			//**************************************************************
			// Tests for UploadTicket
			//**************************************************************
			ts.addTest( Test( new ValueObjectTest("testUploadTicketId") ) );
			ts.addTest( Test( new ValueObjectTest("testUploadTicketPhotoId") ) );
			ts.addTest( Test( new ValueObjectTest("testUploadTicketIsComplete") ) );
			ts.addTest( Test( new ValueObjectTest("testUploadTicketIsInvalid") ) );
			ts.addTest( Test( new ValueObjectTest("testUploadTicketUploadFailed") ) );
			
			//**************************************************************
			// Tests for User
			//**************************************************************
			ts.addTest( Test( new ValueObjectTest("testUserNsid") ) );
			ts.addTest( Test( new ValueObjectTest("testUserUsername") ) );
			ts.addTest( Test( new ValueObjectTest("testUserFullname") ) );
			ts.addTest( Test( new ValueObjectTest("testUserIsPro") ) );
			ts.addTest( Test( new ValueObjectTest("testUserBandwidthMax") ) );
			ts.addTest( Test( new ValueObjectTest("testUserBandwidthUsed") ) );
			ts.addTest( Test( new ValueObjectTest("testUserFilesizeMax") ) );
			ts.addTest( Test( new ValueObjectTest("testUserUrl") ) );
			ts.addTest( Test( new ValueObjectTest("testUserIsIgnored") ) );
			ts.addTest( Test( new ValueObjectTest("testUserIsFriend") ) );
			ts.addTest( Test( new ValueObjectTest("testUserIsFamily") ) );
			ts.addTest( Test( new ValueObjectTest("testUserIsAdmin") ) );
			ts.addTest( Test( new ValueObjectTest("testUserIconServer") ) );
			ts.addTest( Test( new ValueObjectTest("testUserMboxSha1Sum") ) );
			ts.addTest( Test( new ValueObjectTest("testUserLocation") ) );
			ts.addTest( Test( new ValueObjectTest("testUserPhotoUrl") ) );
			ts.addTest( Test( new ValueObjectTest("testUserProfileUrl") ) );
			ts.addTest( Test( new ValueObjectTest("testUserFirstPhotoUploadDate") ) );
			ts.addTest( Test( new ValueObjectTest("testUserFirstPhotoTakenDate") ) );
			ts.addTest( Test( new ValueObjectTest("testUserPhotoCount") ) );
			ts.addTest( Test( new ValueObjectTest("testUserTags") ) );
			
			return ts;
		}
		
		//**************************************************************
		//
		// Tests for AuthResult
		//
		//**************************************************************
		
		public function testAuthResultToken():void {
			var authResult:AuthResult = new AuthResult();
			
			authResult.token = "test";
			assertTrue( "token == 'test'", authResult.token == "test" );
		}
		
		public function testAuthResultPerms():void {
			var authResult:AuthResult = new AuthResult();
			
			authResult.perms = AuthPerm.WRITE;
			assertTrue( "perms == AuthPerm.WRITE", authResult.perms == AuthPerm.WRITE );
		}
		
		public function testAuthResultUser():void {
			var authResult:AuthResult = new AuthResult();
			
			var user:User = new User();
			authResult.user = user;
			assertTrue( "user correct", authResult.user == user );
		}
		
		//**************************************************************
		//
		// Tests for Blog
		//
		//**************************************************************
		
		public function testBlogId():void {
			var blog:Blog = new Blog();
			
			blog.id = "98123";
			assertTrue( "id correct", blog.id = "98123" );
		}
		
		public function testBlogName():void {
			var blog:Blog = new Blog();
			
			blog.name = "test";
			assertTrue( "name correct", blog.name == "test" );
		}
		
		public function testBlogNeedsPassword():void {
			var blog:Blog = new Blog();
			
			blog.needsPassword = true;
			assertTrue( "needsPassword correct", blog.needsPassword == true );
		}
		
		public function testBlogUrl():void {
			var blog:Blog = new Blog();
			
			blog.url = "http://www.test.com";
			assertTrue( "name correct", blog.url == "http://www.test.com" );
		}
		
		//**************************************************************
		//
		// Tests for Category
		//
		//**************************************************************
		
		public function testCategoryId():void {
			var category:Category = new Category();
			
			category.id = "123@N00";
			assertTrue( "id correct", category.id == "123@N00" );
		}
		
		public function testCategoryName():void {
			var category:Category = new Category();
			
			category.name = "test name";
			assertTrue( "name correct", category.name == "test name" );
		}
		
		public function testCategoryPath():void {
			var category:Category = new Category();
			
			category.path = "/path";
			assertTrue( "path correct", category.path == "/path" );
		}
		
		public function testCategoryPathIds():void {
			var category:Category = new Category();
			
			category.pathIds = "/65";
			assertTrue( "pathds correct", category.pathIds = "/65" );
		}
		
		public function testCategoryCount():void {
			var category:Category = new Category();
			
			category.count = 2;
			assertTrue( "count correct", category.count == 2 );
		}
		
		public function testCategorySubCategories():void {
			var category:Category = new Category();
			
			var subCategories:Array = new Array();
			category.subCategories = subCategories;
			assertTrue( "subCategories correct", category.subCategories == subCategories );
		}
		
		public function testCategoryGroups():void {
			var category:Category = new Category();
			
			var groups:Array = new Array();
			category.groups = groups;
			assertTrue( "groups correct", category.groups == groups );
		}
		
		//**************************************************************
		//
		// Tests for Group
		//
		//**************************************************************
		
		public function testGroupNsid():void {
			var group:Group = new Group();
			
			group.nsid = "123@N00";
			assertTrue( "nsid correct", group.nsid == "123@N00" );
		}
		
		public function testGroupName():void {
			var group:Group = new Group();
			
			group.name = "test name";
			assertTrue( "name correct", group.name == "test name" );
		}
		
		public function testGroupDescription():void {
			var group:Group = new Group();
			
			group.description = "test description";
			assertTrue( "description correct", group.description == "test description" );
		}
		
		public function testGroupPrivacy():void {
			var group:Group = new Group();
			
			group.privacy = 3;
			assertTrue( "privacy correct", group.privacy == 3 );
		}
		
		public function testGroupMembers():void {
			var group:Group = new Group();
			
			group.members = 3;
			assertTrue( "members correct", group.members == 3 );	
		}
		
		public function testGroupOnline():void {
			var group:Group = new Group();
			
			group.online = 3;
			assertTrue( "online correct", group.online == 3 );
		}
		
		public function testGroupChatNsid():void {
			var group:Group = new Group();
			
			group.chatNsid = "123@N00";
			assertTrue( "chatNsid correct", group.chatNsid == "123@N00" );
		}
		
		public function testGroupInChat():void {
			var group:Group = new Group();
			
			group.inChat = 3;
			assertTrue( "inChat correct", group.inChat == 3 );
		}
		
		public function testGroupIsEighteenPlus():void {
			var group:Group = new Group();
			
			group.isEighteenPlus = true;
			assertTrue( "isEighteenPlus correct", group.isEighteenPlus == true );	
		}
		
		public function testGroupIsAdmin():void {
			var group:Group = new Group();
			
			group.isAdmin = true;
			assertTrue( "isAdmin correct", group.isAdmin == true );	
		}
		
		public function testGroupPhotos():void {
			var group:Group = new Group();
			
			group.photos = 2;
			assertTrue( "photos correct", group.photos == 2 );	
		}
		
		public function testGroupIconServer():void {
			var group:Group = new Group();
			
			group.iconServer = 1;
			assertTrue( "iconServer correct", group.iconServer == 1 );	
		}
		
		public function testGroupUrl():void {
			var group:Group = new Group();
			
			group.url = "test url"
			assertTrue( "url correct", group.url == "test url" );	
		}
		
		//**************************************************************
		//
		// Tests for License
		//
		//**************************************************************
		
		public function testLicenseId():void {
			var license:License = new License();
			
			license.id = License.ATTRIBUTION;
			assertTrue( "id correct", license.id == License.ATTRIBUTION );	
		}
		
		public function testLicenseName():void {
			var license:License = new License();
			
			license.name = "test name";
			assertTrue( "name correct", license.name == "test name" );	
		}
		
		public function testLicenseUrl():void {
			var license:License = new License();
			
			license.url = "test url";
			assertTrue( "url correct", license.url == "test url" );
		}
		
		//**************************************************************
		//
		// Tests for PagedGroupList
		//
		//**************************************************************
		
		public function testPagedGroupListPage():void {
			var pagedGroupList:PagedGroupList = new PagedGroupList();
			
			pagedGroupList.page = 1;
			assertTrue( "page correct", pagedGroupList.page == 1 );
		}
		
		public function testPagedGroupListPages():void {
			var pagedGroupList:PagedGroupList = new PagedGroupList();
			
			pagedGroupList.pages = 1;
			assertTrue( "pages correct", pagedGroupList.pages == 1 );
		}
		
		public function testPagedGroupListPerPage():void {
			var pagedGroupList:PagedGroupList = new PagedGroupList();
			
			pagedGroupList.perPage = 1;
			assertTrue( "perPage correct", pagedGroupList.perPage == 1 );
		}
		
		public function testPagedGroupListTotal():void {
			var pagedGroupList:PagedGroupList = new PagedGroupList();
			
			pagedGroupList.total = 1;
			assertTrue( "total correct", pagedGroupList.total == 1 );
		}
		
		public function testPagedGroupListGroups():void {
			var pagedGroupList:PagedGroupList = new PagedGroupList();

			var groups:Array = new Array();
			pagedGroupList.groups = groups;
			assertTrue( "groups correct", pagedGroupList.groups == groups );
		}
		
		//**************************************************************
		//
		// Tests for PagedPhotoList
		//
		//**************************************************************
		
		public function testPagedPhotoListPage():void {
			var pagedPhotoList:PagedPhotoList = new PagedPhotoList();
			
			pagedPhotoList.page = 1;
			assertTrue( "page correct", pagedPhotoList.page == 1 );
		}
		
		public function testPagedPhotoListPages():void {
			var pagedPhotoList:PagedPhotoList = new PagedPhotoList();
			
			pagedPhotoList.pages = 1;
			assertTrue( "pages correct", pagedPhotoList.pages == 1 );
		}
		
		public function testPagedPhotoListPerPage():void {
			var pagedPhotoList:PagedPhotoList = new PagedPhotoList();
			
			pagedPhotoList.perPage = 1;
			assertTrue( "perPage correct", pagedPhotoList.perPage == 1 );
		}
		
		public function testPagedPhotoListTotal():void {
			var pagedPhotoList:PagedPhotoList = new PagedPhotoList();
			
			pagedPhotoList.total = 1;
			assertTrue( "total correct", pagedPhotoList.total == 1 );
		}
		
		public function testPagedPhotoListPhotos():void {
			var pagedPhotoList:PagedPhotoList = new PagedPhotoList();

			var photos:Array = new Array();
			pagedPhotoList.photos = photos;
			assertTrue( "photos correct", pagedPhotoList.photos == photos );
		}
		
		//**************************************************************
		//
		// Tests for Photo
		//
		//**************************************************************
		
		public function testPhotoId():void {
			var photo:Photo = new Photo();
			
			photo.id = "123";
			assertTrue( "id correct", photo.id == "123" );
		}
		
		public function testPhotoOwnerId():void {
			var photo:Photo = new Photo();
			
			photo.ownerId = "123";
			assertTrue( "ownerId correct", photo.ownerId == "123" );
		}
		
		public function testPhotoOwnerName():void {
			var photo:Photo = new Photo();
			
			photo.ownerName = "test name";
			assertTrue( "ownerName correct", photo.ownerName == "test name" );
		}
		
		public function testPhotoSecret():void {
			var photo:Photo = new Photo();
			
			photo.secret = "123123";
			assertTrue( "secret correct", photo.secret == "123123" );
		}
		
		public function testPhotoServer():void {
			var photo:Photo = new Photo();
			
			photo.server = 1;
			assertTrue( "server correct", photo.server == 1 );
		}
		
		public function testPhotoIconServer():void {
			var photo:Photo = new Photo();
			
			photo.iconServer = 1;
			assertTrue( "iconServer correct", photo.iconServer == 1 );
		}
		
		public function testPhotoTitle():void {
			var photo:Photo = new Photo();
			
			photo.title = "test title";
			assertTrue( "title correct", photo.title == "test title" );
		}
		
		public function testPhotoDescription():void {
			var photo:Photo = new Photo();
			
			photo.description = "test description";
			assertTrue( "description correct", photo.description == "test description" );
		}
		
		public function testPhotoCommentCount():void {
			var photo:Photo = new Photo();
			
			photo.commentCount = 1;
			assertTrue( "commentCount correct", photo.commentCount == 1 );
		}
		
		public function testPhotoIsPublic():void {
			var photo:Photo = new Photo();
			
			photo.isPublic = true;
			assertTrue( "isPublic correct", photo.isPublic == true );
		}
		
		public function testPhotoIsFriend():void {
			var photo:Photo = new Photo();
			
			photo.isFriend = true;
			assertTrue( "isFriend correct", photo.isFriend == true );
		}
		
		public function testPhotoIsFamily():void {
			var photo:Photo = new Photo();
			
			photo.isFamily = true;
			assertTrue( "isFamily correct", photo.isFamily == true );
		}
		
		public function testPhotoLicense():void {
			var photo:Photo = new Photo();
			
			photo.license = 1;
			assertTrue( "license correct", photo.license == 1 );
		}
		
		public function testPhotoDateUploaded():void {
			var photo:Photo = new Photo();
			
			var date:Date = new Date();
			photo.dateUploaded = date;
			assertTrue( "dateUploaded correct", photo.dateUploaded == date );
		}
		
		public function testPhotoDateTaken():void {
			var photo:Photo = new Photo();
			
			var date:Date = new Date();
			photo.dateTaken = date;
			assertTrue( "dateTaken correct", photo.dateTaken == date );
		}
		
		public function testPhotoDateAdded():void {
			var photo:Photo = new Photo();
			
			var date:Date = new Date();
			photo.dateAdded = date;
			assertTrue( "dateAdded correct", photo.dateAdded == date );
		}
		
		public function testPhotoOriginalFormat():void {
			var photo:Photo = new Photo();
			
			photo.originalFormat = "jpg";
			assertTrue( "originalFormat correct", photo.originalFormat == "jpg" );
		}
		
		public function testPhotoUrl():void {
			var photo:Photo = new Photo();
			
			photo.url = "/photos/bees/2980/";
			assertTrue( "url correct", photo.url == "/photos/bees/2980/" );
		}
		
		public function testPhotoExifs():void {
			var photo:Photo = new Photo();
			
			var exifs:Array = new Array();
			photo.exifs = exifs;
			assertTrue( "exifs correct", photo.exifs == exifs );
		}
		
		public function testPhotoRotation():void {
			var photo:Photo = new Photo();
			
			photo.rotation = 90;
			assertTrue( "rotation correct", photo.rotation == 90 );
		}
		
		public function testPhotoOwnerRealName():void {
			var photo:Photo = new Photo();
			
			photo.ownerRealName = "test name";
			assertTrue( "ownerRealName correct", photo.ownerRealName = "test name" );
		}
		
		public function testPhotoOwnerLocation():void {
			var photo:Photo = new Photo();
			
			photo.ownerLocation = "owner location";
			assertTrue( "ownerLocation correct", photo.ownerLocation == "owner location" );
		}
		
		public function testPhotoIsFavorite():void {
			var photo:Photo = new Photo();
			
			photo.isFavorite = true;
			assertTrue( "isFavorite correct", photo.isFavorite == true );
		}
		
		public function testPhotoCommentPermission():void {
			var photo:Photo = new Photo();
			
			photo.commentPermission = 1;
			assertTrue( "commentPermission correct", photo.commentPermission == 1 );
		}
		
		public function testPhotoAddMetaPermission():void {
			var photo:Photo = new Photo();
			
			photo.addMetaPermission = 1;
			assertTrue( "addMetaPermission correct", photo.addMetaPermission == 1 );
		}
		
		public function testPhotoCanComment():void {
			var photo:Photo = new Photo();
			
			photo.canComment = 1;
			assertTrue( "canComment correct", photo.canComment == 1 );
		}
		
		public function testPhotoCanAddMeta():void {
			var photo:Photo = new Photo();
			
			photo.canAddMeta = 1;
			assertTrue( "canAddMeta correct", photo.canAddMeta == 1 );
		}
		
		public function testPhotoNotes():void {
			var photo:Photo = new Photo();
			
			var notes:Array = new Array();
			photo.notes = notes;
			assertTrue( "notes correct", photo.notes == notes );
		}
		
		public function testPhotoTags():void {
			var photo:Photo = new Photo();
			
			var tags:Array = new Array();
			photo.tags = tags;
			assertTrue( "tags correct", photo.tags == tags );
		}
		
		public function testPhotoUrls():void {
			var photo:Photo = new Photo();
			
			var urls:Array = new Array();
			photo.urls = urls;
			assertTrue( "urls correct", photo.urls == urls );
		}
		
		//**************************************************************
		//
		// Tests for PhotoContext
		//
		//**************************************************************
		
		public function testPhotoContextSets():void {
			var photoContext:PhotoContext = new PhotoContext();
			
			var sets:Array = new Array();
			photoContext.sets = sets;
			assertTrue( "sets correct", photoContext.sets == sets );
		}
		
		public function testPhotoContextPools():void {
			var photoContext:PhotoContext = new PhotoContext();
			
			var pools:Array = new Array();
			photoContext.pools = pools;
			assertTrue( "pools correct", photoContext.pools == pools );
		}
		
		//**************************************************************
		//
		// Tests for PhotoCount
		//
		//**************************************************************
		
		public function testPhotoCountCount():void {
			var photoCount:PhotoCount = new PhotoCount();
			
			photoCount.count = 2;
			assertTrue( "count correct", photoCount.count == 2 );
		}
		
		public function testPhotoCountFromDate():void {
			var photoCount:PhotoCount = new PhotoCount();
			
			var date:Date = new Date();
			photoCount.fromDate = date;
			assertTrue( "fromDate correct", photoCount.fromDate == date );
		}
		
		public function testPhotoCountToDate():void {
			var photoCount:PhotoCount = new PhotoCount();
			
			var date:Date = new Date();
			photoCount.toDate = date;
			assertTrue( "toDate correct", photoCount.toDate == date );
		}
		
		//**************************************************************
		//
		// Tests for PhotoExif
		//
		//**************************************************************
		
		public function testPhotoExifTagspace():void {
			var photoExif:PhotoExif = new PhotoExif();
			
			photoExif.tagspace = "TIFF";
			assertTrue( "tagspace correct", photoExif.tagspace == "TIFF" );
		}
		
		public function testPhotoExifTagspaceId():void {
			var photoExif:PhotoExif = new PhotoExif();
			
			photoExif.tagspaceId = 1;
			assertTrue( "tagspaceId correct", photoExif.tagspaceId == 1 );
		}
		
		public function testPhotoExifTag():void {
			var photoExif:PhotoExif = new PhotoExif();
			
			photoExif.tag = 271;
			assertTrue( "tag correct", photoExif.tag == 271 );
		}
		
		public function testPhotoExifLabel():void {
			var photoExif:PhotoExif = new PhotoExif();
			
			photoExif.label = "Manufacturer";
			assertTrue( "label correct", photoExif.label == "Manufacturer" );
		}
		
		public function testPhotoExifRaw():void {
			var photoExif:PhotoExif = new PhotoExif();
			
			photoExif.raw = "90/10";
			assertTrue( "raw correct", photoExif.raw == "90/10" );
		}
		
		public function testPhotoExifClean():void {
			var photoExif:PhotoExif = new PhotoExif();
			
			photoExif.clean = "64° 42' 44.14";
			assertTrue( "clean correct", photoExif.clean == "64° 42' 44.14" );
		}
		
		//**************************************************************
		//
		// Tests for PhotoNote
		//
		//**************************************************************
		public function testPhotoNoteId():void {
			var photoNote:PhotoNote = new PhotoNote();
			
			photoNote.id = "313";
			assertTrue( "id correct", photoNote.id == "313" );
		}
		
		public function testPhotoNoteAuthorId():void {
			var photoNote:PhotoNote = new PhotoNote();
			
			photoNote.authorId = "12037949754@N01";
			assertTrue( "authorId correct", photoNote.authorId == "12037949754@N01" );
		}
		
		public function testPhotoNoteAuthorName():void {
			var photoNote:PhotoNote = new PhotoNote();
			
			photoNote.authorName = "Bees";
			assertTrue( "authorName correct", photoNote.authorName == "Bees" );
		}
		
		public function testPhotoNoteRectangle():void {
			var photoNote:PhotoNote = new PhotoNote();
			
			var rectangle:Rectangle = new Rectangle();
			photoNote.rectangle = rectangle;
			assertTrue( "rectangle correct", photoNote.rectangle == rectangle );
		}

		public function testPhotoNoteNote():void {
			var photoNote:PhotoNote = new PhotoNote();
			
			photoNote.note = "foo";
			assertTrue( "note correct", photoNote.note == "foo" );
		}
			
		//**************************************************************
		//
		// Tests for PhotoPool
		//
		//**************************************************************
		
		public function testPhotoPoolId():void {
			var photoPool:PhotoPool = new PhotoPool();
			
			photoPool.id = "1";
			assertTrue( "id correct", photoPool.id == "1" );
		}
		
		public function testPhotoPoolTitle():void {
			var photoPool:PhotoPool = new PhotoPool();
			
			photoPool.title = "test title";
			assertTrue( "title correct", photoPool.title == "test title" );
		}
		
		//**************************************************************
		//
		// Tests for PhotoSet
		//
		//**************************************************************
		
		public function testPhotoSetId():void {
			var photoSet:PhotoSet = new PhotoSet();
			
			photoSet.id = "1";
			assertTrue( "id correct", photoSet.id == "1" );
		}
		
		public function testPhotoSetTitle():void {
			var photoSet:PhotoSet = new PhotoSet();
			
			photoSet.title = "test title";
			assertTrue( "title correct", photoSet.title == "test title" );
		}
		
		public function testPhotoSetUrl():void {
			var photoSet:PhotoSet = new PhotoSet();
			
			photoSet.url = "test url";
			assertTrue( "url correct", photoSet.url == "test url" );
		}
		
		public function testPhotoSetDescription():void {
			var photoSet:PhotoSet = new PhotoSet();
			
			photoSet.description = "test description";
			assertTrue( "description correct", photoSet.description == "test description" );
		}
		
		public function testPhotoSetPhotoCount():void {
			var photoSet:PhotoSet = new PhotoSet();
			
			photoSet.photoCount = 1;
			assertTrue( "photoCount correct", photoSet.photoCount == 1 );
		}
		
		public function testPhotoSetPrimaryPhotoId():void {
			var photoSet:PhotoSet = new PhotoSet();
			
			photoSet.primaryPhotoId = "1";
			assertTrue( "primaryPhotoId correct", photoSet.primaryPhotoId == "1" );
		}
		
		public function testPhotoSetOwnerId():void {
			var photoSet:PhotoSet = new PhotoSet();
			
			photoSet.ownerId = "1";
			assertTrue( "ownerId correct", photoSet.ownerId == "1" );
		}
		
		public function testPhotoSetSecret():void {
			var photoSet:PhotoSet = new PhotoSet();
			
			photoSet.secret = "1";
			assertTrue( "secret correct", photoSet.secret == "1" );
		}
		
		public function testPhotoSetServer():void {
			var photoSet:PhotoSet = new PhotoSet();
			
			photoSet.server = 1;
			assertTrue( "server correct", photoSet.server == 1 );
		}
		
		public function testPhotoSetPhotos():void {
			var photoSet:PhotoSet = new PhotoSet();
			
			var photos:Array = new Array();
			photoSet.photos = photos;
			assertTrue( "photos correct", photoSet.photos == photos );
		}
		
		//**************************************************************
		//
		// Tests for PhotoSize
		//
		//**************************************************************
		
		public function testPhotoSizeLabel():void {
			var photoSize:PhotoSize = new PhotoSize();
			
			photoSize.label = "test";
			assertTrue( "label correct", photoSize.label == "test" );
		}
		
		public function testPhotoSizeWidth():void {
			var photoSize:PhotoSize = new PhotoSize();
			
			photoSize.width = 100;
			assertTrue( "width correct", photoSize.width == 100 );
		}
		
		public function testPhotoSizeHeight():void {
			var photoSize:PhotoSize = new PhotoSize();
			
			photoSize.height = 100;
			assertTrue( "height correct", photoSize.height == 100 );
		}
		
		public function testPhotoSizeUrl():void {
			var photoSize:PhotoSize = new PhotoSize();
			
			photoSize.url = "http://www.flickr.com/photo_zoom.gne?id=2836&size=s";
			assertTrue( "url correct", photoSize.url == "http://www.flickr.com/photo_zoom.gne?id=2836&size=s" );
		}
		
		public function testPhotoSizeSource():void {
			var photoSize:PhotoSize = new PhotoSize();
			
			photoSize.source = "http://www.flickr.com/photos/2836_12037949754@N01_m.jpg";
			assertTrue( "source correct", photoSize.source == "http://www.flickr.com/photos/2836_12037949754@N01_m.jpg" );
		}
		
		//**************************************************************
		//
		// Tests for PhotoTag
		//
		//**************************************************************
		
		public function testPhotoTagId():void {
			var photoTag:PhotoTag = new PhotoTag();
			
			photoTag.id = "1";
			assertTrue( "id correct", photoTag.id == "1" );
		}
		
		public function testPhotoTagAuthorId():void {
			var photoTag:PhotoTag = new PhotoTag();
			
			photoTag.authorId = "12037949754@N01";
			assertTrue( "authorId correct", photoTag.authorId == "12037949754@N01" );
		}
		
		public function testPhotoTagRaw():void {
			var photoTag:PhotoTag = new PhotoTag();
			
			photoTag.raw = "woo yay";
			assertTrue( "raw correct", photoTag.raw == "woo yay" );
		}
		
		public function testPhotoTagTag():void {
			var photoTag:PhotoTag = new PhotoTag();
			
			photoTag.tag = "wooyay";
			assertTrue( "tag correct", photoTag.tag == "wooyay" );
		}
		
		public function testPhotoTagCount():void {
			var photoTag:PhotoTag = new PhotoTag();
			
			photoTag.count = 1;
			assertTrue( "count correct", photoTag.count == 1 );
		}
				
		//**************************************************************
		//
		// Tests for PhotoUrl
		//
		//**************************************************************
		
		public function testPhotoUrlType():void {
			var photoUrl:PhotoUrl = new PhotoUrl();
			
			photoUrl.type = "photopage";
			assertTrue( "type correct", photoUrl.type == "photopage" );
		}
		
		public function testPhotoUrlUrl():void {
			var photoUrl:PhotoUrl = new PhotoUrl();
			
			photoUrl.url = "http://www.flickr.com/photos/bees/2733/";
			assertTrue( "url correct", photoUrl.url == "http://www.flickr.com/photos/bees/2733/" );
		}
		
		//**************************************************************
		//
		// Tests for UploadTicket
		//
		//**************************************************************
		
		public function testUploadTicketId():void {
			var uploadTicket:UploadTicket = new UploadTicket();
			
			uploadTicket.id = "1";
			assertTrue( "id correct", uploadTicket.id == "1" );	
		}
		
		public function testUploadTicketPhotoId():void {
			var uploadTicket:UploadTicket = new UploadTicket();
			
			uploadTicket.photoId = "1";
			assertTrue( "photoId correct", uploadTicket.photoId == "1" );	
		}
		
		public function testUploadTicketIsComplete():void {
			var uploadTicket:UploadTicket = new UploadTicket();
			
			uploadTicket.isComplete = true;
			assertTrue( "isComplete correct", uploadTicket.isComplete == true );	
		}
		
		public function testUploadTicketIsInvalid():void {
			var uploadTicket:UploadTicket = new UploadTicket();
			
			uploadTicket.isInvalid = true;
			assertTrue( "isInvalid correct", uploadTicket.isInvalid == true );	
		}
		
		public function testUploadTicketUploadFailed():void {
			var uploadTicket:UploadTicket = new UploadTicket();
			
			uploadTicket.uploadFailed = true;
			assertTrue( "uploadFailed correct", uploadTicket.uploadFailed == true );	
		}
		
		//**************************************************************
		//
		// Tests for User
		//
		//**************************************************************
		
		public function testUserNsid():void {
			var user:User = new User();
			
			user.nsid = "123123@N00";
			assertTrue( "nsid correct", user.nsid == "123123@N00" );
		}
		
		public function testUserUsername():void {
			var user:User = new User();
			
			user.username = "testuser";
			assertTrue( "username correct", user.username == "testuser" );
		}
		
		public function testUserFullname():void {
			var user:User = new User();
			
			user.fullname = "test user";
			assertTrue( "fullname correct", user.fullname == "test user" );
		}
		
		public function testUserIsPro():void {
			var user:User = new User();
			
			user.isPro = true;
			assertTrue( "ispro correct", user.isPro == true );
		}
		
		public function testUserBandwidthMax():void {
			var user:User = new User();
			
			user.bandwidthMax = 10;
			assertTrue( "bandwidthMax correct", user.bandwidthMax == 10 );
		}
		
		public function testUserBandwidthUsed():void {
			var user:User = new User();
			
			user.bandwidthUsed = 10;
			assertTrue( "bandwidthUsed correct", user.bandwidthUsed == 10 );
		}
		
		public function testUserFilesizeMax():void {
			var user:User = new User();
			
			user.filesizeMax = 10;
			assertTrue( "filesizeMax correct", user.filesizeMax == 10 );
		}
		
		public function testUserUrl():void {
			var user:User = new User();
			
			user.url = "http://www.test.com";
			assertTrue( "url correct", user.url == "http://www.test.com" );
		}
		
		public function testUserIsIgnored():void {
			var user:User = new User();
			
			user.isIgnored = true;
			assertTrue( "isIgnored correct", user.isIgnored == true );
		}
		
		public function testUserIsFriend():void {
			var user:User = new User();
			
			user.isFriend = true;
			assertTrue( "isFriend correct", user.isFriend == true );
		}
		
		public function testUserIsFamily():void {
			var user:User = new User();
			
			user.isFamily = true;
			assertTrue( "isFamily correct", user.isFamily == true );
		}
		
		public function testUserIsAdmin():void {
			var user:User = new User();
			
			user.isAdmin = true;
			assertTrue( "isAdmin correct", user.isAdmin == true );
		}
		
		public function testUserIconServer():void {
			var user:User = new User();
			
			user.iconServer = 1;
			assertTrue( "iconServer correct", user.iconServer == 1 );
		}
		
		public function testUserMboxSha1Sum():void {
			var user:User = new User();
			
			user.mboxSha1Sum = "123123";
			assertTrue( "mboxSha1Sum correct", user.mboxSha1Sum == "123123" );
		}
		
		public function testUserLocation():void {
			var user:User = new User();
			
			user.location = "test location";
			assertTrue( "location correct", user.location == "test location" );
		}
		
		public function testUserPhotoUrl():void {
			var user:User = new User();
			
			user.photoUrl = "http://www.flickr.com/photos/";
			assertTrue( "photoUrl correct", user.photoUrl == "http://www.flickr.com/photos/" );
		}
		
		public function testUserProfileUrl():void {
			var user:User = new User();
			
			user.profileUrl = "http://www.flickr.com/people/";
			assertTrue( "profileUrl correct", user.profileUrl == "http://www.flickr.com/people/" );
		}
		
		public function testUserFirstPhotoUploadDate():void {
			var user:User = new User();
			
			var date:Date = new Date();
			user.firstPhotoUploadDate = date;
			assertTrue( "photoUrl correct", user.firstPhotoUploadDate == date );
		}
		
		public function testUserFirstPhotoTakenDate():void {
			var user:User = new User();
			
			var date:Date = new Date();
			user.firstPhotoTakenDate = date;
			assertTrue( "firstPhotoTakenDate correct", user.firstPhotoTakenDate == date );
		}
		
		public function testUserPhotoCount():void {
			var user:User = new User();
			
			var date:Date = new Date();
			user.photoCount = 1;
			assertTrue( "photoCount correct", user.photoCount == 1 );
		}
		
		public function testUserTags():void {
			var user:User = new User();
			
			var tags:Array = new Array();
			user.tags = tags;
			assertTrue( "tagscorrect", user.tags == tags );
		}
		
	}
}