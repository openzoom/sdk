////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007-2009, Daniel Gasienica <daniel@gasienica.ch>
//
//  OpenZoom is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  OpenZoom is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with OpenZoom. If not, see <http://www.gnu.org/licenses/>.
//
////////////////////////////////////////////////////////////////////////////////
jQuery.noConflict();

jQuery(document).ready(function()
{
    replaceImages();
})
 
function replaceImages()
{
    jQuery('img').each(function()
    {
        var width = jQuery(this).attr('width');
        var height = jQuery(this).attr('height');
        var image = '<img src="' + jQuery(this).attr('src') + '" width="' + width + '" height="' + height + '">';
        var source = jQuery(this).attr('openzoom:source');
        var viewerId = "viewer" + Math.floor(Math.random() * 10000);
        var viewer = getEmbedHTML(source, width, height, image, viewerId);
        
        if (source != null && source != "")
            jQuery(this).replaceWith(viewer);
    });
}

function getEmbedHTML(source, width, height, alternate, id)
{
    return '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" ' +
           ' width="'+ width +'" height="'+ height +'" id="' + id + '" name="' + id + '">' +
           '  <param name="movie" value="OpenZoomViewer.swf"/>' +
           '  <param name="scale" value="noscale" />' +
           '  <param name="bgcolor" value="#111111" />' +
           '  <param name="allowfullscreen" value="true"/>' +
           '  <param name="allowscriptaccess" value="always" />' +
           '  <param name="flashvars" value="source=' + source + '"/>' +
           '  <!--[if !IE]>-->' +
           '  <object type="application/x-shockwave-flash" data="OpenZoomViewer.swf" ' +
           '   width="'+ width +'" height="'+ height +'" name="' + id + '">' +
           '    <param name="scale" value="noscale" />' +
           '    <param name="bgcolor" value="#111111" />' +
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
