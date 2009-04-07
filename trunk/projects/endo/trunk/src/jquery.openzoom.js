/*
 * OpenZoom Endo 0.3
 * http://openzoom.org/
 *
 * Copyright (c) 2007-2009, Daniel Gasienica <daniel@gasienica.ch>
 * License: GNU General Public License v3
 * <http://www.gnu.org/licenses/gpl.html>
 */
(function($) {
    $.openzoom = {};
    $.openzoom.run = function () {
	    $("img").each(function() {
	        var width = $(this).attr("width");
	        var height = $(this).attr("height");
	        var image = "<img src=\"" + $(this).attr("src") + "\" width=\"" + width + "\" height=\"" + height + "\">";
	        var source = $(this).attr("openzoom:source");
	        var viewerId = "viewer" + Math.floor(Math.random() * 0x424f);
	        var defaults = {
	            viewer: "OpenZoomViewer.swf",
	            background: "#111111"
	        };
	        var viewer = getEmbedHTML(source, width, height, image, viewerId, defaults);
	        
	        if (source != null && source != "")
	            $(this).replaceWith(viewer);
	    });
	    
	    function getEmbedHTML(source, width, height, alternate, id, options) {
	        return '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" ' +
	               ' width="'+ width +'" height="'+ height +'" id="' + id + '" name="' + id + '">' +
	               '  <param name="movie" value="' + options.viewer + '"/>' +
	               '  <param name="scale" value="noscale" />' +
	               '  <param name="bgcolor" value="' + options.background + '" />' +
	               '  <param name="allowfullscreen" value="true"/>' +
	               '  <param name="allowscriptaccess" value="always" />' +
	               '  <param name="flashvars" value="source=' + source + '"/>' +
	               '  <!--[if !IE]>-->' +
	               '  <object type="application/x-shockwave-flash" data="' + options.viewer + '" ' +
	               '   width="'+ width +'" height="'+ height +'" name="' + id + '">' +
	               '    <param name="scale" value="noscale" />' +
	               '    <param name="bgcolor" value="' + options.background + '" />' +
	               '    <param name="allowfullscreen" value="true" />' +
	               '    <param name="allowscriptaccess" value="always" />' +
	               '    <param name="flashvars" value="source=' + source + '"/>' +
	               '  <!--<![endif]-->' +
	                       alternate +
	               '  <!--[if !IE]>--> ' +
	               '  </object>' +
	               '  <!--<![endif]-->' +
	               '</object>';
	    }
    }
})(jQuery);
