/*
This code is licensed under the MIT License:

Copyright (c) 2007 Ali Rantakari

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
package org.hasseg.externalMouseWheel
{
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.InteractiveObject;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.MouseEvent;
    import flash.external.ExternalInterface;
    import flash.geom.Point;
    
    
    /**
    * Implements mouse wheel support for OS X.
    * This is done by catching mouse wheel events in JavaScript through the
    * ExternalInterface, finding the topmost InteractiveObject under the mouse
    * and making it dispatch the as MouseEvents. 
    * 
    * @author Ali Rantakari ( http://hasseg.org/blog ) - Feel free to use, given that this notice stays intact
    * @author Pavel fljot ( http://inreflected.com ) - a couple of changes + pure AS3-projects support (v1.5)
    */
    public final class ExternalMouseWheelSupport extends EventDispatcher
    {
        /*
        * Purposefully non-AsDoc'd Changelog:
        * 
        * ---------------------------------------------------------------------------------
        * VERSION 1.0 (Ali Rantakari)
        * July 2007
        * 
        * - Initial implementation
        * 
        * 
        * ---------------------------------------------------------------------------------
        * VERSION 1.5 (Changes by Pavel fljot, http://inreflected.com)
        * Jan 2008
        * 
        * 1. initialization by getInstance(stage:Stage) method, that gets reference to the Stage;
        * 2. getAllInteractiveObjectsOnStage() is renamed to getMouseEnabledInteractiveObjectsOnStage()
        *    and returns only objects that are really listening to the mouse at the moment;
        * 3. added filtration into getRegisteredObjects() method for _manuallyRegisteredObjects
        *    (for same purposes as getMouseEnabledInteractiveObjectsOnStage() ).
        * 
        * 
        * ---------------------------------------------------------------------------------
        * VERSION 2.0 (Changes by Ali Rantakari)
        * Apr 2008
        * 
        * - Some minor code cleanup (both syntax & implementation -- tried to make
        *   the code a bit more readable and clear)
        * - Some minor fixes & additions in comments (for the same purpose as above)
        * - Renamed some methods to better depict what they do
        * - Removed try/catch block from initJSConnection() (formerly initialize()) in order to
        *   let the errors be propagated onwards instead of hiding them in the log
        * - Made getInstance() throw an error if the aStage parameter is null
        * - Used flash.events.MouseEvent instead of our own mouse event class
        *   (can't remember why I did that in the first place..?)
        * - Added support for modifier keys (ctrl (i.e. command on a Mac,) alt, shift)
        * - Added an another method for determining the InteractiveObject under mouse
        *   to dispatch the wheel event, courtesy of pixelbreaker.com's solution. Also
        *   added a property for selecting which one of these methods to use
        * - Removed option for manual registration of objects (if one wants to exclude
        *   an object from mouse events, they should use the mouseEnabled property)
        * - Added property "initialized"
        * 
        */
        
        
        /**
        * A possible value for <code>dispatchingObjectDeterminationMethod</code>.
        * 
        * @see #dispatchingObjectDeterminationMethod
        */
        public static const COPY_MOUSEMOVE_EVENTS:uint = 0;
        /**
        * A possible value for <code>dispatchingObjectDeterminationMethod</code>.
        * 
        * @see #dispatchingObjectDeterminationMethod
        */
        public static const TRAVERSE_DISPLAY_LIST:uint = 1;
        
        
        private static var _stage:Stage;        
        
        private var _initialized:Boolean = false;
        
        private var _dispatchingObjectDeterminationMethod:uint = COPY_MOUSEMOVE_EVENTS; // default
        private var _lastMoveEventTarget:InteractiveObject = null;
        private var _lastMoveEventLocalCoords:Point = null;
        
        
        
        
        
        // BEGIN: singleton pattern implementation          ----------------------------------------------------------- 
        
        private static var _INSTANCE:ExternalMouseWheelSupport = null;
        
        /**
        * @private
        */
        public function ExternalMouseWheelSupport(aSingletonEnforcer:SingletonEnforcer):void
        {
            if (_INSTANCE != null)
            {
                throw new Error("You can't create more than one instance of this class because it is a singleton. Use ExternalMouseWheelSupport.instance to get a handle to it.");
            }
            else
            {
                _lastMoveEventLocalCoords = new Point(0,0);
                dispatchingObjectDeterminationMethod = _dispatchingObjectDeterminationMethod; // call setter to attach listener if applicable
                initJSConnection();
            }
        }
        
        /**
        * Returns the reference to the singleton instance of this class
        * 
        * @param aStage     Reference to the Stage object (required!)
        * 
        * @return           Reference to the singleton instance of this class
        */
        public static function getInstance(aStage:Stage):ExternalMouseWheelSupport
        {
            if (aStage == null)
                throw new Error("aStage property can not be null");
            else
            {
                _stage = aStage;
                if (_INSTANCE == null) _INSTANCE = new ExternalMouseWheelSupport(new SingletonEnforcer());
                return _INSTANCE;
            }
        }
        
        // --end--: singleton pattern implementation        - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        // BEGIN: private methods           ----------------------------------------------------------- 
        
        
        // initialize the JavaScript connection:
        // - add ExternalInterface callback so JavaScript can send us the wheel events
        // - call the mw_initialize() JavaScript function
        private function initJSConnection():void
        {
            if (ExternalInterface.available)
            {
                ExternalInterface.addCallback("dispatchExternalMouseWheelEvent", externalMouseWheelEventHandler);
                _initialized = ExternalInterface.call("extMouseWheel.initCaptureFor", ExternalInterface.objectID);
                dispatchEvent(new Event("initializedChanged"));
            }
        }
        
        
        // handler for the calls coming from JavaScript
        private function externalMouseWheelEventHandler(aDelta:int, aX:Number, aY:Number, aCtrlKey:Boolean, aAltKey:Boolean, aShiftKey:Boolean, aButtonDown:Boolean):void
        {
            var mouseEvent:MouseEvent;
            
            if (_dispatchingObjectDeterminationMethod == COPY_MOUSEMOVE_EVENTS)
            {
                if (_lastMoveEventTarget != null)
                {
                    mouseEvent = 
                        new MouseEvent(MouseEvent.MOUSE_WHEEL, true, false,
                                        _lastMoveEventLocalCoords.x, _lastMoveEventLocalCoords.y,
                                        null, //relatedObject -- doesn't apply here
                                        aCtrlKey, aAltKey, aShiftKey, aButtonDown, aDelta);
                    _lastMoveEventTarget.dispatchEvent(mouseEvent);
                }
            }
            else if (_dispatchingObjectDeterminationMethod == TRAVERSE_DISPLAY_LIST)
            {
                var iaObjs:Array = getMouseEnabledInteractiveObjectsOnStage();
                
                if (iaObjs.length > 0)
                {
                    // see which ones pass a hittest with the mouse cursor
                    var hitTestObjs:Array = iaObjs.filter(function(aItem:*, aIndex:int, aArray:Array):Boolean {
                        return (aItem.hitTestPoint(aX,aY,true));
                    });
                    
                    // create array of hittest-passing objects and their levels in the displaylist
                    var rObjs:Array = getDisplayListLevelsFor(hitTestObjs);
                    
                    // see which ones of the remaining are highest in the displaylist
                    var highestLevel:uint = 0;
                    for (var m:uint = 0; m < rObjs.length; m++)
                    {
                        if (rObjs[m].level > highestLevel) highestLevel = rObjs[m].level;
                    }
                    var onTheHighestLevel:Array = rObjs.filter(function(aItem:*, aIndex:int, aArray:Array):Boolean {
                        return (aItem.level == highestLevel);
                    });
                    
                    // pick the last one from the ones that have the highest level
                    var highestInDisplayList:Object = {object:null, level:(-10000)};
                    for (var n:uint = 0; n < onTheHighestLevel.length; n++)
                    {
                        if (onTheHighestLevel[n].level > highestInDisplayList.level) highestInDisplayList = onTheHighestLevel[n];
                    }
                    
                    // make it dispatch a MouseEvent.MOUSE_WHEEL event
                    if (highestInDisplayList.object != null)
                    {
                        if (highestInDisplayList.object.dispatchEvent)
                        {
                            //var mouseEvent:ExternalMouseWheelEvent = new ExternalMouseWheelEvent(ExternalMouseWheelEvent.MOUSE_WHEEL, aDelta, aX, aY);
                            var localCoords:Point = highestInDisplayList.object.globalToLocal(new Point(aX, aY));
                            mouseEvent = 
                                new MouseEvent(MouseEvent.MOUSE_WHEEL, true, false,
                                                localCoords.x, localCoords.y,
                                                null, //relatedObject -- doesn't apply here
                                                aCtrlKey, aAltKey, aShiftKey, aButtonDown, aDelta);
                            highestInDisplayList.object.dispatchEvent(mouseEvent);
                        }
                    }
                }
            }
        }
        
        
        
        // save topmost InteractiveObject on stage under mouse
        private function stageMouseMoveHandler(event:MouseEvent):void
        {
            _lastMoveEventTarget = InteractiveObject(event.target);
            _lastMoveEventLocalCoords.x = event.localX;
            _lastMoveEventLocalCoords.y = event.localY;
        }
        
        
        
        
        
        
        
        
        /**
        * Returns an array of Objects, specifying the display list levels
        * for a specified array of DisplayObjects. The return Object will
        * be in the following format:
        * 
        * <code>{object:<DisplayObject>, level:<uint>}</code>
        * 
        * @param aObjs      An array of DisplayObjects
        * 
        * @return           An array of Objects, containing the
        *                   objects and their levels in the DisplayList
        */
        private function getDisplayListLevelsFor(aObjs:Array):Array
        {
            var objs:Array = new Array();
            
            if (aObjs.length > 0)
            {
                if (aObjs[0].stage != null)
                {
                    objs = travelDisplayList(aObjs[0].stage);
                    var currLevel:uint = 0;
                    
                    function travelDisplayList(container:DisplayObjectContainer):Array
                    {
                        var retArr:Array = new Array();
                        var child:DisplayObject;
                        for (var i:uint=0; i < container.numChildren; i++)
                        {
                            currLevel++;
                            child = container.getChildAt(i);
                            if (aObjs.indexOf(child) != (-1)) retArr.push({object:child, level:currLevel});
                            if (container.getChildAt(i) is DisplayObjectContainer)
                            {
                                var grandChildren:Array = travelDisplayList(DisplayObjectContainer(child));
                                for (var j:uint = 0; j < grandChildren.length; j++)
                                    retArr.push(grandChildren[j]);
                            }
                        }
                        return retArr;
                    }
                }
            }
            
            return objs;
        }
        
        
        
        
        // returns all the InteractiveObjects on stage that are able to
        // dispatch mouse events
        private function getMouseEnabledInteractiveObjectsOnStage():Array
        {
            var objs:Array = new Array();
            
            objs = travelDisplayList(_stage);
            
            function travelDisplayList(container:DisplayObjectContainer):Array
            {
                var retArr:Array = new Array();
                var child:DisplayObject;
                for (var i:uint=0; i < container.numChildren; i++)
                {
                    child = container.getChildAt(i);
                    if (child is InteractiveObject)
                    {
                        if (!child.visible)
                            continue;
                        
                        if ((child as InteractiveObject).mouseEnabled)
                            retArr.push(child);
                        
                        // fljot: get children only if they are mouse-enabled. otherwise no need to scan them
                        if (child is DisplayObjectContainer && (child as DisplayObjectContainer).mouseChildren)
                        {
                            var grandChildren:Array = travelDisplayList(DisplayObjectContainer(child));
                            for (var j:uint = 0; j < grandChildren.length; j++)
                                retArr.push(grandChildren[j]);
                        }
                    }
                }
                return retArr;
            }
            
            return objs;
        }
        
        
        
        // checks whether a given object is "mouse-enabled" -- i.e. if it's supposed
        // to be able to dispatch mouse events.
        private function objectIsMouseEnabled(aObj:InteractiveObject, aCheckMouseEnabledProperty:Boolean = true):Boolean
        {
            var isEnabled:Boolean = true;
            
            if (!aObj.visible || (aCheckMouseEnabledProperty && !aObj.mouseEnabled))
                isEnabled = false;
            
            if (isEnabled && aObj.parent)
            {
                // fljot: need to check parents if they are visible
                if (!(aObj.parent as DisplayObjectContainer).mouseChildren)
                    isEnabled = false;
                else
                    isEnabled = objectIsMouseEnabled(aObj.parent, false);
            }
            
            return isEnabled;
        }
        
        // --end--: private methods     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        
        
        
        
        
        
        
        
        
        
        
        
        
        // BEGIN: public methods            ----------------------------------------------------------- 
        
        
        /**
        * Specifies the method of determining the InteractiveObject that will
        * be called to dispatch the external mouse wheel events received from
        * JavaScript.
        * 
        * <p>The possible values are:</p>
        * <table class="innertable">
        * <tr>  <th>Constant to use</th><th>Description</th></tr>
        * <tr>  <td>ExternalMouseWheelSupport.COPY_MOUSEMOVE_EVENTS</td>
        *       <td>
        *       With this method, a <code>mouseMove</code> event listener will be
        *       added to the Stage and the object to dispatch a mouse wheel
        *       event when one arrives via JavaScript will be the same one
        *       that was the target for the last such <code>mouseMove</code>
        *       event.
        *       </td></tr>
        * <tr>  <td>ExternalMouseWheelSupport.TRAVERSE_DISPLAY_LIST</td>
        *       <td>
        *       With this method, each time a mouse wheel event arrives via
        *       JavaScript the object to dispatch the event will be determined
        *       by traversing the display list hierarchy and finding the
        *       topmost matching object under the mouse cursor.
        *       </td></tr>
        * </table>
        * 
        * @see #COPY_MOUSEMOVE_EVENTS
        * @see #TRAVERSE_DISPLAY_LIST
        */
        public function get dispatchingObjectDeterminationMethod():uint
        {
            return _dispatchingObjectDeterminationMethod;
        }
        /**
        * @private
        */
        public function set dispatchingObjectDeterminationMethod(aVal:uint):void
        {
            if (aVal != COPY_MOUSEMOVE_EVENTS && aVal != TRAVERSE_DISPLAY_LIST)
                return;
            
            if (aVal == COPY_MOUSEMOVE_EVENTS && _stage != null)
                _stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler, false, 0, true);
            else if (aVal == COPY_MOUSEMOVE_EVENTS && _stage != null)
                _stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler, false);
            
            _dispatchingObjectDeterminationMethod = aVal;
        }
        
        
        
        /**
        * Whether or not the external mouse wheel support has been
        * successfully initialized. Note that an unsuccessful initialization
        * might mean that the support is simply not needed (i.e. if running
        * in Windows Flash Player in a browser other than Safari.)
        */
        [Bindable(event="initializedChanged")]
        public function get initialized():Boolean
        {
            return _initialized;
        }
        
        
        
        // --end--: public methods      - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        
        
    }
    
    
}

class SingletonEnforcer {}


