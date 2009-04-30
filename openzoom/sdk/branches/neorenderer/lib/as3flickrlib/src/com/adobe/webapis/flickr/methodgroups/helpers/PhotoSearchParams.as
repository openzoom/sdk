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

package com.adobe.webapis.flickr.methodgroups.helpers
{
	public class PhotoSearchParams
	{
 		public var user_id:String = "";
		public var tags:String = "";
		public var tag_mode:String = "any"; 
		public var text:String = "";
		public var min_upload_date:Date = null;
		public var max_upload_date:Date = null; 
		public var min_taken_date:Date = null;
		public var max_taken_date:Date = null;
		public var license:Number = -1;
		public var sort:String = "date-posted-desc";
		public var privacy_filter:int = -1;
		public var bbox:String = "";
		public var accuracy:int = -1;
		public var safe_search:int = -1;
		public var content_type:int = -1;
		public var machine_tags:String = "";
		public var machine_tag_mode:String = "";
		public var group_id:String = "";
		public var contacts:String = "";
		public var woe_id:String = "";
		public var place_id:String = "";
		public var media:String = "";
		public var has_geo:Boolean = false;//true; false or all
		public var lat:String = "";
		public var lon:String = "";
		public var radius:Number = -1;
		public var radius_units:Number = -1;
		public var extras:String = "";
		public var per_page:Number = 100;
		public var page:Number = 1;
	}
}