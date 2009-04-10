/*
 * OpenZoom Endo 0.4
 * http://openzoom.org/
 *
 * Copyright (c) 2007-2009, Daniel Gasienica <daniel@gasienica.ch>
 * License: GNU General Public License v3
 * <http://www.gnu.org/licenses/gpl.html>
 */
(function(a){a.openzoom={};a.openzoom.run=function(){a("img").each(function(){var d=a(this).attr("width"),c=a(this).attr("height"),e=a(this).attr("openzoom:source"),h='<img src="'+a(this).attr("src")+'" width="'+d+'" height="'+c+'">',i="viewer"+Math.floor(Math.random()*16975),f={viewer:"OpenZoomViewer.swf",background:"#111111"},g=b(e,d,c,h,i,f);if(e!=null&&e!=""){a(this).replaceWith(g)}});function b(f,e,c,g,h,d){return'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="'+e+'" height="'+c+'" id="'+h+'" name="'+h+'"><param name="movie" value="'+d.viewer+'"/><param name="scale" value="noscale" /><param name="bgcolor" value="'+d.background+'" /><param name="allowfullscreen" value="true"/><param name="allowscriptaccess" value="always" /><param name="flashvars" value="source='+f+'"/><!--[if !IE]>--><object type="application/x-shockwave-flash" data="'+d.viewer+'" width="'+e+'" height="'+c+'" name="'+h+'"><param name="scale" value="noscale" /><param name="bgcolor" value="'+d.background+'" /><param name="allowfullscreen" value="true" /><param name="allowscriptaccess" value="always" /><param name="flashvars" value="source='+f+'"/><!--<![endif]-->'+g+"<!--[if !IE]>--> </object><!--<![endif]--></object>"}}})(jQuery);
jQuery.noConflict();jQuery(document).ready(function(){jQuery.openzoom.run()});
