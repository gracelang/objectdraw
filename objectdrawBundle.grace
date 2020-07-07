dialect "standard"
import "dom" as dom
import "random" as random
import "sys" as sys
import "intrinsic" as intrinsic

// ** Helpers ***************************************************

type Foreign = Unknown

def document: Foreign = dom.document

def frameRate:Number = 30      // The frame rate of the drawing

trait open {

    method randomNumberFrom (m: Number) to (n: Number) -> Number {
        // A pseudo-random number in the interval [m..n)
        ((n - m) * random.between0And1) + m
    }

    // ** Types ********************************************************************

    type Component = Object & interface {
        // The super-type of all components in a GUI.

        element     // The underlying DOM element of the component.
        width -> Number     // The width of this component
        height -> Number    // The height of this component.
        size -> Point       // The size (width, height) of this component

        onMouseClickDo (f: MouseResponse) -> Done
        // Respond to a mouse click (press and release) in this component by executing f

        onMousePressDo (f: MouseResponse) -> Done
        // Respond to a mouse press in this component by executing f.

        onMouseReleaseDo (f: MouseResponse) -> Done
        // Respond to a mouse release in this component by executing f.

        onMouseMoveDo (f: MouseResponse) -> Done
        // Respond to a mouse move in this component by executing f.

        onMouseDragDo (f: MouseResponse) -> Done
        // Respond to a mouse drag (move during press) in this component by executing f.

        onMouseEnterDo (f: MouseResponse) -> Done
        // Respond to a mouse entering this component by executing f.

        onMouseExitDo (f: MouseResponse) -> Done
        // Respond to a mouse exiting this component by executing f.

        onKeyTypeDo (f: KeyResponse) -> Done
        // Respond to a key type (press and release) in this component by executing f.

        onKeyPressDo (f: KeyResponse) -> Done
        // Respond to a key press in this component by executing f.

        onKeyReleaseDo (f: KeyResponse) -> Done
        // Respond to a key release in this component by executing f.

        isFlexible -> Boolean
        // will this component fill any empty space in the
        // direction of its parent container.

        flexible := (value: Boolean) -> Done
        // Sets whether this component will fill empty space in the
        // direction of its parent container.
    }

    type Container = Component & interface {
        // The type of components that contain other components.

        size -> Number  // The number of components inside this container.

        at (index: Number) -> Component
        // Retrieve the component at the given index.

        at (index: Number) put(component: Component) -> Done
        // Put the given component at the given index.

        append (component: Component) -> Done
        // Add a component to the end of the container.

        prepend (component: Component) -> Done
        // Add a component to the start of the container.

        do (f: Procedure1⟦Component⟧) -> Done
        // Perform the action f for every component inside this container.

        arrangeHorizontal -> Done
        // Arrange the contents of this container horizontally.
        // Components that exceed the width of the container will wrap around.

        arrangeVertical -> Done
        // Arrange the contents of this container vertically.
        // Components that exceed the height of the container will wrap around.
    }

    type Application = Container & interface {
        // A standalone window that contains other components.

        windowTitle -> String
        // The title of this application window.

        windowTitle:= (value: String) -> Done
        // Sets the title of the application window.

        startApplication -> Done
        // Makes this window visible, with active listeners for mouse actions

        stopApplication -> Done
        // Close this window
    }

    type Graphic = Object & interface {
        // an object that can be drawn on a canvas and moved around.

        location -> Point
        // Tte location of this object with respect to the top-left corner of the screen.

        x -> Number
        // the horizontal offset of this object from the left edge of the screen.

        y -> Number
        // Tte vertical offset of this object from the top of the screen.

        addToCanvas (canvas: DrawingCanvas) -> Done
        // adds this object to canvas.

        removeFromCanvas -> Done
        // removes this object from its canvas.

        isVisible -> Boolean
        // whether this object is currently visible on the canvas.

        visible:= (value: Boolean) -> Done
        // sets whether this object should be visible on the canvas.

        moveTo(newLocation: Point) -> Done
        // moves this object to newLocation on the canvas.

        moveBy(dx: Number, dy: Number) -> Done
        // moves this object on the canvas by dx horizontally, and dy vertically.

        contains(pt: Point) -> Boolean
        // is pt is inside this object?

        overlaps(graphic: Graphic2D) -> Boolean
        // is any point in graphic also inside this object?

        color := (c: Color)->Done
        // sets the color of this object to c

        color -> Color
        // answers the color of this object

        sendForward -> Done
        // sends this object up one layer on the screen

        sendBackward -> Done
        // sends this object down one layer on the screen

        sendToFront -> Done
        // sends this object to the top layer on the screen

        sendToBack -> Done
        // sends this object to the bottom layer on the screen
    }

    type DrawingCanvas = Component & interface {
        // a canvas that can hold Graphic objects

        startDrawing -> Done
        // redraws the canvas and its contents regularly as needed

        add (d: Graphic)->Done
        // adds d to canvas

        remove (d: Graphic)->Done
        // removes d from canvas

        notifyRedraw -> Done
        // informs me that I need to be redrawn

        clear -> Done
        // clears the canvas

        sendToFront (d: Graphic) -> Done
        // sends d to top layer of graphics

        sendToBack (d: Graphic) -> Done
        // sends d to bottom layer of graphics

        sendForward (d: Graphic) -> Done
        // sends d up one layer in graphics

        sendBackward (d: Graphic) -> Done
        // sends d down one layer in graphics
    }

    type GraphicApplication = Application & interface {
        // Type of an object that runs a graphical application that draws
        // on a canvas displayed in a window, and responds to mouse actions

        canvas -> DrawingCanvas
        // canvas holds graphic objects on screen

        onMouseClick (m: Point) -> Done
        // Respond to a mouse click (press and release) in the canvas at m

        onMousePress (m: Point) -> Done
        // Respond to a mouse press in the canvas at m

        onMouseRelease (m: Point) -> Done
        // Respond to a mouse release in the canvas at m

        onMouseMove (m: Point) -> Done
        // Respond to a mouse move in the canvas at tm

        onMouseDrag (m: Point) -> Done
        // Respond to a mouse drag (move during press) in the canvas at m

        onMouseEnter (m: Point) -> Done
        // Respond to a mouse entering the canvas at m

        onMouseExit (m: Point) -> Done
        // Respond to a mouse exiting the canvas at m

        startGraphics -> Done
        // makes this object's window visisble, along with its contents, and
        // prepares the window to handle mouse events
    }

    type Graphic2D = Graphic & interface {
        // Two-dimensional objects that have a size, and can be resized

        width -> Number     // dimensions of this object
        height -> Number
        size -> Point

        size := (dimensions: Point) -> Done     // change dimensions of this object
        width := (newWidth: Number) -> Done
        height := (newHeight: Number) -> Done
    }


    type Line = Graphic & interface {
        // One-dimensional objects

        start -> Point      // start of this line
        end -> Point        // end of this line

        start := (start': Point) -> Done    // sets start of this line to start'
        end := (end': Point) -> Done        // sets end of this line to end'
        setEndPoints (start': Point, end': Point) -> Done  // sets both start and end
    }

    type Text = Graphic & interface {
        // Text that can be drawn on a canvas.

        contents -> String                  // return my contents
        contents := (s: String) -> Done     // sets my contents to s
        width -> Number                     // returns the width of my content (currently inaccurate)
        fontSize -> Number                  // return size of the font used to display my contents
        fontSize := (size: Number) -> Done  // sets the size of the font used to display my contents
    }

    type TextBox = Component & interface {
        // Component of window that can hold text

        contents -> String                  // The text contents of this box.
        contents:= (value: String) -> Done

    }

    type Labeled = Component & interface {
        // Component of window that holds text

        label -> String                     // The label name.
        label:= (value: String) -> Done

    }

    type Button = Labeled
        // type of button component in window

    type Input = Component & interface {
        // Component taking input and responding to an event

        onFocusDo(f: Response) -> Done
        // Respond to this input gaining focus with the given event.

        onBlurDo(f: Response) -> Done
        // Respond to this input losing focus with the given event.

        onChangeDo(f: Response) -> Done
        // Respond to this input having its value changed.
    }

    type TextField = Input & interface {    // Component taking user's text input
        text -> String                      // The contents of the field
        text := (value: String) -> Done     // changes text
    }

    type NumberField = Input & interface {  // Component taking user's numeric input
        number -> Number                    // The contents of the field.
        number := (value: Number) -> Done   // Changes number
    }

    type Choice = Input & interface {       // Pop-up menus
        selected -> String                  // The currently selected option
        selected := (value: String) -> Done // Changes selected
    }

    // ** Colors *******************************************************************
    type Color = interface {
        red -> Number     // The red component of the color.
        green -> Number   // The green component of the color.
        blue -> Number    // The blue component of the color.
    }

    type ColorFactory = interface {
        r (r': Number) g (g': Number) b (b': Number) -> Color
        random -> Color
        white -> Color
        black -> Color
        green -> Color
        red -> Color
        gray -> Color
        blue -> Color
        cyan -> Color
        magenta -> Color
        yellow -> Color
        neutral -> Color
    }

    once method ColorOutOfRange -> ExceptionKind {
        // the Exception that will be thrown if the r, b, or g components
        // are not between 0 and 255 (inclusive)
        self.ProgrammingError.refine "ColorOutOfRange"
    }

    once class colorGen -> ColorFactory {
        class r (r': Number) g (g': Number) b (b': Number) -> Color {
            use equality
            // Creates a color with rgb coordinates r', g', and b'
            if ((r' < 0) || (r' > 255)) then {
                ColorOutOfRange.raise "red index {r'} out of bounds 0..255"
            }

            if ((g' < 0) || (g' > 255)) then {
                ColorOutOfRange.raise "green index {g'} out of bounds 0..255"
            }

            if ((b' < 0) || (b' > 255)) then {
                ColorOutOfRange.raise "blue index {b'} out of bounds 0..255"
            }

            def red:Number is public = r'.truncated
            def green:Number is public = g'.truncated
            def blue:Number is public = b'.truncated

            method == (c: Color) -> Boolean {
                (red == c.red) && (green == c.green) && (blue == c.blue)
            }

            method hash -> Number {
                hashCombine(hashCombine(red.hash, green.hash), blue.hash)
            }

            method asString -> String {
                "color w/ rgb({red}, {green}, {blue})"
            }
        }

        method random -> Color {
            // return a random color.
            r (random.integerIn 0 to 255)
                  g (random.integerIn 0 to 255)
                  b (random.integerIn 0 to 255)
        }

        def white:Color is public = r 255 g 255 b 255
        def black:Color is public = r 0 g 0 b 0
        def green:Color is public = r 0 g 255 b 0
        def red:Color is public = r 255 g 0 b 0
        def gray:Color is public = r 60 g 60 b 60
        def blue:Color is public = r 0 g 0 b 255
        def cyan:Color is public = r 0 g 255 b 255
        def magenta:Color is public = r 255 g 0 b 255
        def yellow:Color is public = r 255 g 255 b 0
        def neutral:Color is public = r 220 g 220 b 220
    }

    // ** Events *******************************************************************

    type Event = interface {
        // Generic event containing source of the event.
        source -> Component
    }

    type MouseEvent = Event & interface {
        // Mouse event containing mouse location when event generated
        at -> Point
    }

    type KeyEvent = Event & interface {
        // Type of an event associated with a key press

        code -> Number
        //character -> String
        //modifiers -> Modifiers
    }

    type Response = Procedure1⟦Event⟧           // an action taking an Event as argument
    type MouseResponse = Procedure1⟦MouseEvent⟧ // action taking a MouseEvent as argument
    type KeyResponse = Procedure1⟦KeyEvent⟧     // an action taking a KeyEvent as argument

    class eventSource (source':Component) -> Event {
        // Creates an event generated by source'

        def source: Component is public = source'

        method asString -> String {
            "Event on {source}"
        }
    }

    class mouseEventSource (source':Component) event (event':Foreign) -> MouseEvent {
        // Creates a mouseEvent with the mouse location from event'

        inherit eventSource (source')
        def at: Point is public = (event'.pageX - source.element.offsetLeft) @
              (event'.pageY - source.element.offsetTop)

        // String representation of the mouse event
        method asString -> String {
            "Mouse event on {source} at {at}"
        }
    }

    class keyEventSource (source':Component) event(event':Foreign) -> KeyEvent {
        // represents the keyboard event' from source'
        inherit eventSource (source')
        method code → Number { event'.which }
        method character → String { event'.key }
        method shiftKey → Boolean { event'.shiftKey }
        method ctrlKey → Boolean { event'.ctrlKey }
        method altKey → Boolean { event'.altKey }
        method metaKey → Boolean { event'.metaKey }
        method asString → String {
            "an event on {source} for key-code {code}"
        }

    }


    // ** Internal factories *******************************************************

    type ComponentFactory⟦T where T <: Component⟧ = interface {

        fromElement (element) -> T
        // Build a component around the existing element.

        ofElementType (tagName: String) -> T
        // Build a component around a new element with the given tag name.
    }

    once method maxClickTime -> Number { 200 }
        // The maximum number of milliseconds for which the mouse-button can
        // be held down in order for the event to be registered as a click.

    class componentFromElement (element') -> Component {
        def element is public = element'

        method width -> Number {
            // width of component
            element.width
        }

        method height -> Number {
            // height of component
            element.height
        }

        method size -> Point {
            // dimensions of component
            element.width @ element.height
        }

        method on(event': String) do(f: Procedure1⟦Foreign⟧) -> Done is confidential {
            // associates action f with event' on this component
            element.addEventListener(event', f)
            done
        }

        method on (kind: String) withPointDo (f:MouseResponse) -> Done is confidential {
            // associates response f with mouse event of kind
            on (kind) do { event' ->
                f.apply (mouseEventSource (self) event (event'))
            }
        }

        method onMouseClickDo (f:MouseResponse) -> Done {
            // associates action f with mouse click event
            var lastDown: Foreign

            on "mousedown" do {event': Foreign ->
                lastDown:= event'.timeStamp
            }

            on "click" do {event': Foreign ->
                if ((event'.timeStamp - lastDown) <= maxClickTime) then {
                    f.apply (mouseEventSource(self) event(event'))
                }
            }
        }

        method onMousePressDo (f: MouseResponse) -> Done {
            // Associates action f with any mouse press event
            on "mousedown" withPointDo (f)
        }

        method onMouseReleaseDo (f: MouseResponse) -> Done {
            // Associates action f with any mouse release event
            on "mouseup" withPointDo (f)
        }

        method onMouseMoveDo (f: MouseResponse) -> Done {
            // Associates action f with any mouse move event
            on "mousemove" do { event' ->
                if (if (dom.doesObject (event') haveProperty ("buttons")) then {
                    event'.buttons == 0
                } else {
                    event'.which == 0
                }) then {
                    f.apply(mouseEventSource (self) event (event'))
                }
            }
        }

        method onMouseDragDo (f: MouseResponse) -> Done {
            // Associate action f with mouse drag event
            on "mousemove" do { event' ->
                if (if (dom.doesObject (event') haveProperty ("buttons")) then {
                    event'.buttons == 1
                } else {
                    event'.which == 1
                }) then {
                    f.apply(mouseEventSource (self) event(event'))
                }
            }
        }

        method onMouseEnterDo (f: MouseResponse) -> Done {
            // Associate action f with  mouse enter (of window) event
            on "mouseover" do { event' ->
                def from = event'.relatedTarget
                if ((dom.noObject == from) || {!element.contains(from)}) then {
                    f.apply (mouseEventSource (self) event (event'))
                }
            }
        }

        method onMouseExitDo (f: MouseResponse) -> Done {
            // Associate action f with mouse exit event
            on "mouseout" do {event' ->
                def to = event'.relatedTarget

                if ((dom.noObject == to) || {!element.contains (to)}) then {
                    f.apply (mouseEventSource (self) event (event'))
                }
            }
        }

        method on (kind: String)
            // Associate action f with key event of kind
              withKeyDo (f: KeyResponse) -> Done is confidential {
            on (kind) do {event' ->
                f.apply (keyEventSource (self) event (event'))
            }
        }

        method onKeyPressDo(f: KeyResponse) -> Done {
            // Associate action f with key press event
            on "keydown" withKeyDo (f)
        }

        method onKeyReleaseDo (f: KeyResponse) -> Done {
            // Associate action f with key release event
            on "keyup" withKeyDo (f)
        }

        method onKeyTypeDo (f: KeyResponse) -> Done {
            // Associate action f with key type (press & release) event
            on "keypress" withKeyDo (f)
        }

        method isFlexible -> Boolean {
            // Does this component have flexible size?
            element.style.flexGrow.asNumber > 0
        }

        method flexible:= (value: Boolean) -> Done {
            // Sets whether I am flexibile
            element.style.flexGrow := if (value) then {
                1
            } else {
                0
            }
        }

        method asString -> String { "a component" }
    }

    class componentOfElementType (tagName:String) -> Component {
        // Creates a component with type tagName

        inherit componentFromElement (document.createElement (tagName))
    }


    class containerOfElementType (tagName: String) -> Component {
        inherit containerFromElement (document.createElement (tagName))
    }


    class containerFromElement (element') -> Container {
        // Create a and return new Container from element'
        inherit componentFromElement (element')

        def children = list []

        method size -> Number {
            // answers the number of children of this container
            children.size
        }
        method isEmpty -> Boolean {
            // is this container empty?
            size == 0
        }
        method at (index: Number) -> Component {
            // returns my subcomponent at position index
            children.at (index)   // children.at will check bounds
        }
        method at (index: Number) put (aComponent: Component) -> Done {
            // replaces subcomponent at index by aComponent
            if ((index < 1) || (index > (size + 1))) then {
                BoundsError.raise
                    "Can't put component at {index} because I have only {size} elements"
            }

            if (index == (size + 1)) then {
                element.appendChild (aComponent.element)
            } else {
                element.insertBefore (aComponent.element, children.at (index).element)
            }
            children.at (index) put (aComponent)
            done
        }
        method append (aComponent: Component) -> Done {
            // adds aComponent after all my existing components
            element.appendChild (aComponent.element)
            children.push (aComponent)
            done
        }
        method prepend (aComponent: Component) -> Done {
            // adds aComponent before all my existing components
            if (isEmpty) then {
                element.appendChild (aComponent.element)
            } else {
                element.insertBefore (aComponent.element, element.firstChild)
            }
            children.unshift (aComponent)
            done
        }
        method do (f: Procedure1⟦Component⟧) -> Done {
            // apply f to all my children
            children.do {aComponent: Component ->
                f.apply(aComponent)
            }
        }
        method fold⟦T⟧(f: Function2⟦T, Component, T⟧) startingWith (initial: T) -> T {
            // answers the fold of the binary function f over all my children.
            // answers initial if I have no children.
            var value:T := initial

            children.do {aComponent: Component ->
                value:= f.apply (value, aComponent)
            }

            value
        }
        method flex -> Done is confidential {
            // makes me more flexible
            element.style.display := "inline-flex"
            element.style.justifyContent := "center"
            element.style.flexFlow := "row wrap"
        }
        method arrangeHorizontal -> Done {
            // arranges my elements in rows
            flex
            element.style.flexDirection:= "row"
        }
        method arrangeVertical -> Done {
            // Arranges my elements in columns
            flex
            element.style.flexDirection := "column"
        }
        method asString -> String {
            // answers a description of me
            "container: with {size} children"
        }
    }

    class emptyContainer -> Container {
        // creates and returns an empty container ready to add in row

        inherit containerOfElementType "div"
        self.arrangeHorizontal
    }

    class containerSize (width':Number, height':Number) -> Container {
        // creates and returns an empty container with width' and height'

        inherit emptyContainer
        self.element.style.width:= "{width'}px"
        self.element.style.height:= "{height'}px"
        self.element.style.overflow:= "auto"
    }

    class inputFromElement (element') -> Input {
        // A factory building components that take input

        inherit componentFromElement(element')

        method onFocusDo (f: Response) -> Done {
            // Respond with action f to this input gaining focus with the given event.
            element.addEventListener ("focus", { _ ->
                f.apply(eventSource(self))
            })
        }

        method onBlurDo (f: Response) -> Done {
            // Respond with action f to this input losing focus with the given event.
            element.addEventListener("blur", { _ ->
                f.apply(eventSource(self))
            })
        }

        method onChangeDo (f: Response) -> Done {
            // Respond with action f to this input having its value changed.
            element.addEventListener ("change", { _ ->
                f.apply(eventSource(self))
            })
        }

        method asString -> String {
            // return description of component
            "an input"
        }
    }

    class inputOfElementType(elementType: String) -> Input {
        // Create component of type elementType to handle input
        inherit inputFromElement (document.createElement (elementType))
    }

    class inputOfType (inputType: String) -> Input {
        // Create component of type inputType to handle input
        inherit inputOfElementType("input")

        self.element.setAttribute ("type", inputType)

    }

    class labeledWidgetFromElement (element') -> Labeled {
        // create labeled input from element'

        inherit inputFromElement (element')

        var labeler:Foreign  // debug -- work around for selectBox

        method labelElement -> Foreign is confidential {
            self.element
        }

        method label -> String {
            // answers the Text of the label
            labelElement.textContent
        }

        method label:= (value: String) -> Done {
            // sets the label to value
            labelElement.textContent:= value
            done
        }

        method asString -> String {
            // a human-readable description of this object
            "an input labeled: {label}"
        }
    }

    class labeledWidgetOfElementType (elementType:String) -> Labeled {
        // creates labeled input a new document of elementType

        inherit labeledWidgetFromElement (document.createElement (elementType))
    }

    class labeledWidgetOfElementType (elementType: String)
          labeled(newLabel: String) -> Labeled {
        // Create labeled element from elementType with newLabel

        inherit labeledWidgetOfElementType(elementType)

        // method to help get initialization code right in choice elements
        method init -> Done is confidential {}
        init

        self.label := newLabel
    }

    class fieldOfType(inputType: String) labeled(label': String) -> Input {
        // Create input field of type inputType showing label'

        inherit inputOfType(inputType)

        // label on the field
        method label -> String {
            self.element.placeholder
        }

        // reset the label on the field
        method label:= (value: String) -> Done {
            self.element.placeholder:= value
            done
        }

        // String representing the labeled field (including label)
        method asString -> String {
            "a field labeled: {label}"
        }

        label:= label'

    }


    // ** External factories *******************************************************

    class eventLogKind(kind': String) response(response': Response) is confidential {
        // Log entry to keep track of response to an event
        def kind: String is public = kind'
        def response: Response is public = response'
    }

    class applicationTitle(initialTitle: String) size (dimensions': Point) -> Application {
        // returns an Application with window with initialTitle and dimensions'

        inherit containerFromElement(document.createDocumentFragment)
            alias containerElement = element
            alias containerArrangeHorizontal = arrangeHorizontal
            alias containerArrangeVertical = arrangeVertical

        var isOpened: Boolean:= false  // whether window is visible
        var theWindow: Foreign

        var theTitle: String:= initialTitle
        var theWidth: Number:= dimensions'.x
        var theHeight: Number:= dimensions'.y

        def events = list []

        method element -> Foreign {
            if (isOpened) then {
                theWindow.document.body
            } else {
                containerElement
            }
        }

        // Whether new items are added to window from left to right or top to bottom
        var isHorizontal: Boolean:= true

        // Arrange the contents of this container along the horizontal axis.
        // Components that exceed the width of the container will wrap around.
        method arrangeHorizontal -> Done {
            if (isOpened) then {
                containerArrangeHorizontal
            } else {
                isHorizontal:= true
            }
        }

        // Arrange the contents of this container along the vertical axis.
        // Components which exceed the height of the container will wrap around.
        method arrangeVertical -> Done {
            if (isOpened) then {
                containerArrangeVertical
            } else {
                isHorizontal:= false
            }
        }

        // Associate response with event kind
        method on (kind: String)
              do (response: Procedure1⟦Event⟧) -> Done is confidential {
            if (isOpened) then {
                theWindow.addEventListener (kind, response)
            } else {
                events.push (eventLogKind (kind) response (response))
            }
        }

        // The title of the application window.
        method windowTitle -> String {
            if (isOpened) then {
                theWindow.title
            } else {
                theTitle
            }
        }

        // Set the title of the application window.
        method windowTitle:= (value: String) -> Done {
            if (isOpened) then {
                theWindow.title:= value
            } else {
                theTitle:= value
            }
        }

        // The current width of the window
        method width -> Number {
            if (isOpened) then {
                theWindow.width
            } else {
                theWidth
            }
        }

        // the current height of the window
        method height -> Number {
            if (isOpened) then {
                theWindow.height
            } else {
                theHeight
            }
        }

        // The enter/exit events need to be redefined to account for the body element
        // not necessarily accounting for all of the space in the window. If we only
        // consider cases where relatedTarget is null, then it represents only enter
        // and exit of the whole window.

        // Respond to a mouse entering this window with the response f.
        method onMouseEnterDo(f: MouseResponse) -> Done {
            on "mouseover" do { event' ->
                def from = event'.relatedTarget

                if (dom.noObject == from) then {
                    f.apply(mouseEventSource(self) event(event'))
                }
            }
        }

        // Respond to a mouse exiting this window with the response f.
        method onMouseExitDo(f: MouseResponse) -> Done {
            on "mouseout" do { event' ->
                def to = event'.relatedTarget

                if (dom.noObject == to) then {
                    f.apply(mouseEventSource(self) event(event'))
                }
            }
        }

        // Respond to mouse action of kind with response bl
        method onMouse (kind: String) do (bl: MouseResponse) -> Done is confidential {
            theWindow.addEventListener(kind, {evt ->
                bl.apply(evt.pageX @ evt.pageY)
            })
        }

        // Create window with listeners for mouse enter and exit actions
        method startApplication -> Done {
            if (!isOpened) then {
                theWindow:= dom.window.open("", "", "width={theWidth},height={theHeight}")
                if (intrinsic.inBrowser && (dom.noObject == theWindow)) then {
                    print "Failed to open the graphics window.\nIs your browser blocking pop-ups?"
                    sys.exit 1
                }
                theWindow.document.title:= theTitle
                theWindow.document.body.appendChild(element)

                if (dom.doesObject(dom.window) haveProperty("graceRegisterWindow")) then {
                    dom.window.graceRegisterWindow(theWindow)
                }

                isOpened:= true

                element.style.width:= "100%"
                element.style.margin:= "0px"

                if (isHorizontal) then {
                    arrangeHorizontal
                } else {
                    arrangeVertical
                }

                events.do { anEvent ->
                    on(anEvent.kind) do(anEvent.response)
                }
            }
        }

        // Close the window
        method stopApplication  -> Done {
            if (isOpened) then {
                theWindow.close
            }
        }

        // Return string representing the application
        method asString -> String {
            "application titled {windowTitle}"
        }
    }

    class drawingCanvasSize (dimensions': Point) -> DrawingCanvas {
        // class representing a window panel that manages graphics on screen
        // The window containing the canvas has dimensions width' x height'

        inherit componentFromElement(document.createElement("canvas"))

        element.width:= dimensions'.x
        element.height:= dimensions'.y
        element.style.alignSelf:= "center"

        def theContext: Foreign = element.getContext("2d")
        theContext.lineWidth:= 2

        // Current width of the canvas
        method width -> Number {
            element.width
        }

        // Current height of the canvas
        method height -> Number {
            element.height
        }

        method size -> Point {element.width @ element.height}

        var theGraphics := list [ ]   // all the objects on this canvas (hidden or not)

        var redraw: Boolean:= false

        method notifyRedraw -> Done {
            // tels this canvas that it needs to be redrawn
            redraw:= true
        }

        // redraws the canvas and its contents regularly as needed
        method startDrawing -> Done {
            element.ownerDocument.defaultView.setInterval ({
                if (redraw) then {
                    dom.draw (theContext, theGraphics, width, height)
                }
            }, 1000 / frameRate)
        }

        // remove all items from canvas
        method clear -> Done {
            theGraphics.clear
            notifyRedraw
        }

        // Add new item d to canvas
        method add (d:Graphic) -> Done {
            theGraphics.push(d)
            notifyRedraw
        }

        // remove aGraphic from items on canvas
        method remove (aGraphic: Graphic) -> Done {
            if (theGraphics.contains(aGraphic)) then {
                theGraphics.remove (aGraphic)
                notifyRedraw
            }
        }

        // send item d to front/top layer of canvas
        method sendToFront (aGraphic: Graphic) -> Done {
            theGraphics.remove (aGraphic)
            theGraphics.push (aGraphic)
            notifyRedraw
        }

        // send item d to back/bottom layer of canvas
        method sendToBack (aGraphic: Graphic) -> Done {
            theGraphics.remove (aGraphic)
            theGraphics.unshift (aGraphic)
            notifyRedraw
        }

        // send item d one layer higher on canvas
        method sendForward (aGraphic: Graphic) -> Done {
            def theIndex = theGraphics.indexOf (aGraphic)

            if (theIndex != theGraphics.size) then {
                theGraphics.remove (aGraphic)
                theGraphics.at (theIndex + 1) add (aGraphic)
                notifyRedraw
            }
        }

        // send item d one layer lower on canvas
        method sendBackward (aGraphic: Graphic)->Done {
            def theIndex = theGraphics.indexOf(aGraphic)

            if (theIndex != 1) then {
                theGraphics.remove (aGraphic)
                theGraphics.at (theIndex - 1) add (aGraphic)
                notifyRedraw
            }
        }

        // debug method to print all objects on canvas
        method printObjects -> Done {
            theGraphics.do { aGraphic ->
                print (aGraphic)
            }
        }

        // string representation of canvas
        method asString -> String {
            "canvas: with {theGraphics.size} objects"
        }
    }

    class graphicApplicationSize (theDimension':Point) -> GraphicApplication {
        // Create window with dimensions theDimension', with canvas
        // installed, and that responds to mouse actions

        inherit applicationTitle ("Simple graphics") size (theDimension')

        def canvas: DrawingCanvas is public = drawingCanvasSize (theDimension')

        children.push (canvas)

        def before: Container = emptyContainer
        def after: Container = emptyContainer

        arrangeVertical
        element.appendChild (before.element)
        element.appendChild (canvas.element)
        element.appendChild (after.element)

        // Add a component to the top of the window.
        method prepend (aComponent: Component) -> Done {
            before.prepend (aComponent)
            children.unshift (aComponent)
        }

        // Add a component to the bottom of the window.
        method append (aComponent: Component) -> Done {
            after.append (aComponent)
            children.push (aComponent)
        }

        // The following methods are defind to be called in response to mouse
        // actions.  They will be overridden in subclasses to provide appropriate
        // behavior, as now they do nothing!
        // Method to handle mouse click at pt
        method onMouseClick (pt: Point) -> Done {}

        // Method to handle mouse press at pt
        method onMousePress (pt: Point) -> Done {}

        // Method to handle mouse release at pt
        method onMouseRelease (pt: Point) -> Done {}

        // Method to handle mouse move at pt
        method onMouseMove (pt: Point) -> Done {}

        // Method to handle mouse drag at pt
        method onMouseDrag (pt: Point) -> Done {}

        // Method to handle mouse enter of canvas at pt
        method onMouseEnter (pt: Point) -> Done {}

        // Method to handle mouse exit of canvas at pt
        method onMouseExit (pt: Point) -> Done {}

        // Create window and its contents as well as prepare the
        // window to handle mouse events
        method startGraphics -> Done {
            def parentElement = document.createElement ("div")
            parentElement.className := "height-calculator"
            parentElement.style.width := "{theDimension'.x}px"
            parentElement.appendChild (element.cloneNode (true))
            document.body.appendChild (parentElement)
            theHeight:= parentElement.offsetHeight
            document.body.removeChild (parentElement)

            startApplication
            canvas.startDrawing

            theWindow.document.documentElement.style.overflow := "hidden"

            canvas.onMouseClickDo { event' ->
                onMouseClick (event'.at)
            }

            canvas.onMousePressDo { event' ->
                onMousePress (event'.at)
            }

            canvas.onMouseReleaseDo { event' ->
                onMouseRelease (event'.at)
            }

            canvas.onMouseMoveDo { event' ->
                onMouseMove (event'.at)
            }

            canvas.onMouseDragDo { event' ->
                onMouseDrag (event'.at)
            }

            canvas.onMouseEnterDo { event' ->
                onMouseEnter (event'.at)
            }

            canvas.onMouseExitDo { event' ->
                onMouseExit (event'.at)
            }
        }

        method asString -> String {
            "graphic application of {canvas}"
        }
    }

    class drawableAt (location':Point) on (canvas':DrawingCanvas) -> Graphic {
        // abstract superclass for drawable objects (of type Graphic)

        use identityEquality

        // location of object on screen
        var location: Point is readable:= location'

        // x coordinate of object
        method x -> Number {
            location.x
        }

        // y coordinate of object
        method y -> Number {
            location.y
        }

        var canvas: DrawingCanvas := canvas'    // The canvas this object is part of

        var theColor: Color:= colorGen.black      // the color of this object

        method color -> Color {theColor}

        method color:= (newColor: Color) -> Done {
            theColor:= newColor
            notifyRedraw
        }

        var theFrameColor: Color := colorGen.black

        method frameColor -> Color { theFrameColor }
        method frameColor := (newfColor:Color) -> Done {
            theFrameColor:= newfColor
            notifyRedraw
        }

        // Determine if object is shown on screen
        var isVisible: Boolean is readable := true

        // Set whether object is visible or hidden
        method visible := (b:Boolean) -> Done {
            isVisible := b
            notifyRedraw
        }

        // Add this object to canvas c
        method addToCanvas (c: DrawingCanvas) -> Done {
            removeFromCanvas
            canvas := c
            c.add (self)
            notifyRedraw
        }

        // Remove this object from its canvas
        method removeFromCanvas -> Done {
            canvas.remove (self)
            notifyRedraw
        }

        // move this object to newLocn
        method moveTo (newLocn: Point) -> Done{
            location := newLocn
            notifyRedraw
        }

        // move this object dx to the right and dy down
        method moveBy (dx: Number, dy: Number) -> Done {
            location := location + (dx @ dy)
            notifyRedraw
        }

        // Determine whether this object contains the point at locn
        method contains (locn: Point) -> Boolean is abstract

        // Determine whether this object overlaps otherObject
        method overlaps (otherObject: Graphic2D) -> Boolean is abstract

        // Send this object up one layer on the screen
        method sendForward -> Done {
            canvas.sendForward (self)
        }

        // send this object down one layer on the screen
        method sendBackward -> Done {
            canvas.sendBackward (self)
        }

        // send this object to the top layer on the screen
        method sendToFront -> Done {
            canvas.sendToFront (self)
        }

        // send this object to the bottom layer on the screen
        method sendToBack -> Done {
            canvas.sendToBack (self)
        }

        // Tell the canvas that the screen needs to be repainted
        method notifyRedraw -> Done is confidential {
            canvas.notifyRedraw
        }

        // Draw this object on the applet !! confidential
        method draw (ctx: Foreign) -> Done is abstract

        // Return a string representation of the object
        method asString -> String {
            "Graphic object"
        }
    }

    class drawable2DAt (location': Point)
          size (dimension': Point) on (canvas': DrawingCanvas) -> Graphic {
        // abstract class for two-dimensional objects

        inherit drawableAt (location') on (canvas')
        var theWidth:Number := dimension'.x
        method width -> Number {theWidth}        // Width of the object

        var theHeight:Number := dimension'.y
        method height -> Number {theHeight}      // Height of the object

        method size -> Point {theWidth @ theHeight}

        // whether the object contains locn
        // Only checks whether is in the bounding box of the object!!
        method contains(locn:Point)->Boolean{
            (x <= locn.x) && (locn.x <= (x + width))
                  && (y <= locn.y) && (locn.y <= (y + height))
        }

        // Whether bounding box of object overlaps bounding box of other
        method overlaps (other:Graphic2D) -> Boolean {
            def itemleft = other.x
            def itemright = other.x + other.width
            def itemtop = other.y
            def itembottom = other.y + other.height
            def disjoint: Boolean = ((x + width) < itemleft) || (itemright < x)
                  || ((y + height) < itemtop) || (itembottom < y)
            !disjoint
        }

        // Return string representation of the object
        method asString -> String {
            "drawable2D object at ({x},{y}) "++
                  "with height {height}, width {width}, and color {self.color}"
        }
    }

    class resizable2DAt (location': Point) size (dimensions': Point)
          on (canvas': DrawingCanvas) -> Graphic2D {
        // abstract class for 2 dimensional objects that can be resized.

        inherit drawable2DAt (location') size (dimensions') on (canvas')

        // Reset width of object to w
        method width:= (w: Number) -> Done {
            theWidth := w
            notifyRedraw
        }

        // Reset height of object to h
        method height := (h: Number) -> Done {
            theHeight := h
            notifyRedraw
        }

        // Reset size of object to w x h
        method size:= (dimensions: Point) -> Done {
            width := dimensions.x
            height := dimensions.y
        }

        // Return string representation of object
        method asString -> String {
            "Resizable2D object at ({x},{y}) "++
                  "with height {height}, width {width}, and color {self.color}"
        }
    }

    class framedRectAt (location': Point) size (dimensions': Point)
          on (canvas': DrawingCanvas) -> Graphic2D {
        // class to generate framed rectangle at (x',y') with size dimensions'
        // created on canvas'

        inherit resizable2DAt (location') size (dimensions') on (canvas')
        addToCanvas (canvas')

        // Draw the framed rectangle on the canvas
        method draw (ctx: Foreign) -> Done {
            def col = self.color
            ctx.save
            ctx.strokeStyle:= "rgb({col.red}, {col.green}, {col.blue})"
            ctx.strokeRect (x, y, width, height)
            ctx.restore
        }

        // Return description of framed rectangle
        method asString -> String {
            "FramedRect at ({x},{y}) "++
                  "with height {height}, width {width}, and color {self.color}"
        }
    }

    class filledRectAt (location': Point) size (dimensions': Point)
          on (canvas': DrawingCanvas) -> Graphic2D {

        // class to generate filled rectangle at (x', y') with size width' x height'
        // created on canvas'
        inherit resizable2DAt (location') size (dimensions') on (canvas')

        addToCanvas (canvas')

        // Draw filled rectangle on the canvas
        method draw (ctx: Foreign) -> Done {
            def col = self.color
            ctx.save
            ctx.fillStyle:= "rgb({col.red}, {col.green}, {col.blue})"
            ctx.fillRect (x, y, width, height)
            ctx.restore
        }

        // Return string representation of the filled rectangle
        method asString -> String {
            "FilledRect at ({x}, {y}) " ++
                  "with height {height}, width {width}, and color {self.color}"
        }
    }


    class framedOvalAt (location': Point) size (dimensions': Point)
          on (canvas': DrawingCanvas) -> Graphic2D {
        // class to generate framed oval at (x',y') with size width' x height'
        // created on canvas'

        inherit resizable2DAt (location') size (dimensions') on (canvas')
        addToCanvas (canvas')

        // draw framed oval on canvas
        method draw (ctx: Foreign) -> Done {
            def col = self.color
            ctx.beginPath
            ctx.save
            ctx.translate (x + width / 2, y + height / 2)
            ctx.scale (width / 2, height / 2)
            ctx.arc (0, 0, 1, 0, 2 * pi)
            ctx.restore
            ctx.save
            ctx.strokeStyle := "rgb({col.red}, {col.green}, {col.blue})"
            ctx.stroke
            ctx.restore
            ctx.closePath
        }

        // string representation of oval
        method asString -> String {
            "FramedOval at ({x},{y}) "++
                  "with height {height}, width {width}, and color {self.color}"
        }
    }

    class filledOvalAt (location': Point) size (dimensions': Point)
          on (canvas': DrawingCanvas) -> Graphic2D {
        // class to generate filled oval at (x',y') with size width' x height'
        // created on canvas'

        inherit resizable2DAt (location') size (dimensions') on (canvas')

        addToCanvas (canvas')

        method draw (ctx: Foreign) -> Done {
            // Draw filled oval on canvas
            def col = self.color
            ctx.beginPath
            ctx.save
            ctx.translate (x + width / 2, y + height / 2)
            ctx.scale (width / 2, height / 2)
            ctx.arc (0, 0, 1, 0, 2 * pi)
            ctx.restore
            ctx.save
            ctx.fillStyle:= "rgb({col.red}, {col.green}, {col.blue})"
            ctx.fill
            ctx.restore
            ctx.closePath
        }

        method asString -> String {
            // string representation of oval
            "FilledOval at ({x},{y}) " ++
                  "with height {height}, width {width}, and color {self.color}"
        }
    }

    class framedArcAt (location': Point) size (dimensions': Point)
          from (startAngle: Number) to (endAngle: Number)
          on (canvas': DrawingCanvas) -> Graphic2D {
        // class to generate framed arc at (x',y') with size width' x height'
        // from startAngle radians to endAngle radians created on canvas'
        // Note that angle 0 is in direction of positive x axis and increases in
        // angles go clockwise.
        inherit resizable2DAt (location') size (dimensions') on (canvas')
        addToCanvas (canvas')

        method draw (ctx: Foreign) -> Done {
            // Draw framed arc
            def col = self.color
            ctx.beginPath
            ctx.save
            ctx.translate (x + width / 2, y + height / 2)
            ctx.scale (width / 2, height / 2)
            if (startAngle <= endAngle) then {
                ctx.arc (0, 0, 1, (startAngle * pi) / 180, (endAngle * pi) / 180)
            } else {
                ctx.arc (0, 0, 1, (endAngle * pi) / 180, (startAngle * pi) / 180)
            }
            ctx.restore
            ctx.save
            ctx.strokeStyle:= "rgb({col.red}, {col.green}, {col.blue})"
            ctx.stroke
            ctx.restore
            ctx.closePath
        }

        method asString -> String {
            // String representation of framed arc
            "FramedArc at ({x},{y}) " ++
                  "with height {height}, width {width}, and color {self.color} going " ++
                  "from {startAngle} degrees to {endAngle} degrees"
        }
    }


    class filledArcAt (location': Point) size (dimensions': Point)
          from (startAngle: Number) to (endAngle: Number)
          on (canvas': DrawingCanvas) -> Graphic2D {
        // class to generate filled arc at (x',y') with size width' x height'
        // from startAngle degrees to endAngle degrees created on canvas'
        // Note that angle 0 is in direction of positive x axis and increases in
        // angles go clockwise.

        inherit resizable2DAt (location') size (dimensions') on (canvas')
        addToCanvas (canvas')

        method draw (ctx: Foreign) -> Done {
            // Draw filled arc on canvas
            def col = self.color
            ctx.beginPath
            ctx.save
            ctx.translate (x + width / 2, y + height / 2)
            ctx.scale (width / 2, height / 2)
            if (startAngle <= endAngle) then {
                ctx.arc (0, 0, 1, (startAngle * pi) / 180, (endAngle * pi) / 180)
            } else {
                ctx.arc (0, 0, 1, (endAngle * pi) / 180, (startAngle * pi) / 180)
            }
            ctx.restore
            ctx.save
            ctx.fillStyle:= "rgb({col.red}, {col.green}, {col.blue})"
            ctx.fill
            ctx.save
            ctx.closePath
        }

        method asString -> String {
            // String representation of filled arc
            "FilledArc at ({x},{y}) " ++
                  "with height {height}, width {width}, and color {self.color} going " ++
                  "from {startAngle} degrees to {endAngle} degrees"
        }
    }

    class drawableImageAt (location': Point)
          size (dimensions': Point)
          url (url: String)
          on (canvas': DrawingCanvas) -> Graphic2D {
        // Creates image from url and places on
        // canvas' at location' with size width' x height'

        inherit resizable2DAt (location') size (dimensions') on (canvas')

        var theImage:= document.createElement("img")
        theImage.src:= url

        theImage.addEventListener("load", { _ ->
            addToCanvas(canvas')
        })

        // draw the image
        method draw(ctx: Foreign) -> Done {
            ctx.drawImage(theImage, x, y, width, height)
        }

        // Return string representation of image
        method asString -> String {
            "DrawableImage at ({x},{y}) "++
                  "with height {height}, width {width}, "++
                  "from url {url}"
        }
    }

    type LineFactory = interface {
        // Type of factory for creating line segments

        from (start:Point) to (end:Point) on (canvas: DrawingCanvas) -> Line
        // Creates a line from start to end on canvas

        from (pt:Point) length (len:Number) direction (radians:Number)
              on (canvas:DrawingCanvas) -> Line
        // Creates a line from pt, of length len, in direction radians, on canvas
    }

    class lineFrom (start': Point) to (end': Point)
          on (canvas': DrawingCanvas) -> Line {
        // Create a line from start' to end' on canvas'

        inherit drawableAt (start') on (canvas')

        var theEnd: Point:= end'

        method start -> Point {
            // position of start of line
            location
        }

        method end -> Point {
            // position of end of line

            theEnd
        }

        addToCanvas (canvas')

        method start := (newStart: Point) -> Done {
            // set start of line

            location := newStart
            notifyRedraw
        }

        method end := (newEnd: Point) -> Done {
            // Set end of line

            theEnd := newEnd
            notifyRedraw
        }

        method setEndPoints (newStart: Point,newEnd: Point) -> Done {
            // Set start and end of line

            start := newStart
            end := newEnd
        }


        method draw (ctx: Foreign) -> Done {
            // Draw the line on the canvas
            def col = self.color
            ctx.save
            ctx.strokeStyle:= "rgb({col.red}, {col.green}, {col.blue})"
            ctx.beginPath
            ctx.moveTo (location.x, location.y)
            ctx.lineTo (theEnd.x, theEnd.y)
            ctx.stroke
            ctx.restore
        }

        method moveBy (dx: Number, dy: Number) -> Done {
            // Moves the line by (dx, dy)

            location := location + (dx @ dy)  //.translate(dx,dy)
            theEnd:= theEnd + (dx @ dy) //.translate(dx,dy)
            notifyRedraw
        }

        method moveTo (newLocn:Point) -> Done {
            // Moves this object to newLocn

            def dx: Number = (newLocn - location).x
            def dy: Number = (newLocn - location).y
            location := newLocn
            theEnd := theEnd + (dx @ dy)
            notifyRedraw
        }


        method dist2 (v: Point, w: Point) -> Number is confidential {
            // answers the square of the distance between v and w
            ((v.x - w.x) ^ 2) + ((v.y - w.y) ^ 2)

        }

        method distToSegmentSquared (p: Point, v: Point, w: Point) -> Number
              is confidential {
            // returns the square of the distance between p and the line through v and w

            var l2: Number:= dist2 (v, w)
            if (l2 == 0) then {return dist2 (p, v)}
            var t: Number:= ((p.x - v.x) * (w.x - v.x) + (p.y - v.y) * (w.y - v.y)) / l2
            if (t < 0) then {return dist2 (p, v)}
            if (t > 1) then {return dist2 (p, w)}
            dist2 (p, ( (v.x + t * (w.x - v.x)) @
                  (v.y + t * (w.y - v.y) )))
        }

        method distToSegment (p: Point, v: Point, w: Point) -> Number {
            // Return the distance from p to the line through v and w
            distToSegmentSquared (p, v, w).sqrt
        }

        method contains(pt:Point) -> Boolean {
            // Answers whether the line contains pt.  Returns true if pt is within
            // 2 pixels of the line

            def tolerance: Number = 2
            distToSegment(pt,start,end) < tolerance
        }

        method asString -> String {
            // Answers a string representation of this line
            "Line from {start} to {end} with color {self.color}"
        }
    }

    class lineFrom (pt: Point) length (len: Number) direction (radians: Number)
          on (canvas':DrawingCanvas) -> Line {
        // Creates a line starting at pt of length len, in direction radians on canvas'

        inherit lineFrom (pt) to (pt +
              ((len * radians.cos) @ (-len * radians.sin))) on (canvas')
    }

    class textAt (location': Point) with (contents': String)
          on(canvas': DrawingCanvas) -> Text {
        // class to generate text at location' on canvas' initially showing
        // contents'
        inherit drawableAt (location') on (canvas')

        var theContents: String:= contents'
        var fsize: Number is readable:= 10
        var wid: Number := theContents.size * fsize / 2
        // Return approximation of the width of the text
        method width -> Number {
            wid
        }

        // Draw the text
        method draw(ctx: Foreign) -> Done {
            def col = self.color
            ctx.save
            ctx.font:= "{fontSize}pt sans-serif"
            ctx.fillStyle:= "rgb({col.red}, {col.green}, {col.blue})"
            ctx.fillText (contents, location.x, location.y)
            wid := ctx.measureText(theContents).width
            ctx.restore
        }

        // Return the string held in the text item (i.e., its contents)
        method contents -> String {
            theContents
        }

        // Reset the contents to newContents
        method contents := (newContents: String) -> Done {
            theContents := newContents
            notifyRedraw
        }

        // Reset the font size to size'
        method fontSize := (size': Number) -> Done {
            fsize := size'
            notifyRedraw
        }

        // Return the size of the font
        method fontSize -> Number {
            fsize
        }

        // Return string representation of the text item
        method asString -> String {
            "Text at ({x},{y}) with value {contents} and color {self.color}"
        }

        addToCanvas(canvas')
    }

    class textBoxWith (contents': String) -> TextBox {
        // Create a component in window that holds the string contents'
        // It cannot respond to user actions

        inherit componentOfElementType "span"

        method contents -> String {
            // the string in this text box
            self.element.textContent
        }

        method contents:= (value: String) -> Done {
            // changes the string in this text box to be `value`
            self.element.textContent:= value
            done
        }

        method asString -> String {
            // a string describing this text box
            "a text box showing {contents}"
        }

        contents:= contents'
    }

    class buttonLabeled (label': String) -> Button {
        // Creates a button with label'
        inherit labeledWidgetOfElementType ("button") labeled (label')

        method asString -> String {
            "a button labeled: {self.label}"
        }
    }

    class textFieldLabeled (label':String) -> TextField {
        // Generates a text field with label'

        inherit fieldOfType ("text") labeled (label')

        method text -> String {
            // answer the text
            self.element.value
        }

        method text:= (value: String) -> Done {
            // Updates the text
            self.element.value:= value
        }

        // Return string representation of the text field
        method asString -> String {
            if (self.label == "") then {
                "a text field with {text}"
            } else {
                "a text field labeled: {self.label} with {text}"
            }
        }
    }

    class textFieldUnlabeled -> TextField {
        // Generates a text field without initial contents

        inherit textFieldLabeled ""
    }


    class passwordFieldLabeled (lab: String) -> Input {
        // Generates password field with initial contents lab

        inherit textFieldLabeled (lab)

        self.element.setAttribute ("type", "password")

        method asString -> String {
            // Return string representation of password field
            if (self.label == "") then {
                "a password field"
            } else {
                "a password field labeled: {self.label}"
            }
        }
    }

    class passwordFieldUnlabeled -> TextField {
        // Generate an unlabeled password field
        inherit passwordFieldLabeled ""
    }

    class numberFieldLabeled (label': String) -> NumberField {
        // Generates a number field with initial contents label'

        inherit fieldOfType("number") labeled (label')

        method number -> Number {
            // Return the number in the field
            self.element.value.asNumber
        }

        method number:= (value: Number) -> Done {
            // update the number in the field
            self.element.value:= value
        }

        method asString -> String {
            // Return description of the number field
            if (self.label == "") then {
                "a number field holding {number}"
            } else {
                "a number field labeled: {self.label} holding {number}"
            }
        }
    }

    class numberFieldUnlabeled -> NumberField {
        // Creates an unlabeled number field
        inherit numberFieldLabeled ""
    }

    class menuWithOptions(options:Collection⟦String⟧) labeled (label':String)
          -> Choice is confidential {
        // Creates choice box with list of items from options; initially shows label'

        inherit labeledWidgetOfElementType("select") labeled(label')
        //        def labeler:Foreign
        method init is override, confidential {
            self.labeler := document.createElement("option")
            labeler.value:= ""
        }

        method labelElement -> Foreign {
            labeler
        }

        self.element.appendChild(labeler)

        options.do { name: String ->
            def anOption: Foreign = document.createElement("option")
            anOption.value:= name
            anOption.textContent:= name
            self.element.appendChild(anOption)
        }

        // Return selected item in menu
        method selected -> String {
            self.element.value
        }

        // Sets selected item in menu to value
        method selected:= (value: String) -> Done {
            self.element.value:= value
        }

        // Return string representation of the menu
        method asString -> String {
            if (self.label == "") then {
                "a pop-up menu"
            } else {
                "a pop-up menu labeled: {self.label}"
            }
        }
    }

    class menuWithOptions (options: Collection⟦String⟧) -> Choice {
        // Creates choice box with list of items from options
        // Initially shows first item in options
        inherit menuWithOptions (options) labeled ""
        self.element.removeChild (self.labelElement)

    }


    type Audio = interface {
        // An audio file that can be played

        source -> String        // The source URL of the audio.
        source:= (value: String) -> Done
        play -> Done            // Play the audio.
        pause -> Done           // Pause playing the audio.
        isLooping -> Boolean    // does the audio loop back to the start?
        looping:= (value: Boolean) -> Done  // determine whether the audio will loop
        isEnded -> Boolean      // whether the audio has finished
    }


    class audioUrl(source': String) -> Audio {
        // Creates an audio file from source', which is a web URL
        def element = document.createElement("audio")

        element.src:= source'

        if (dom.doesObject(dom.window) haveProperty("graceRegisterAudio")) then {
            dom.window.graceRegisterAudio(element)
        }

        // URL of the audio file
        method source -> String {
            element.src
        }

        // Reset the source URL of the audio file
        method source:= (value: String) -> Done {
            element.src:= value
        }

        // Play the audio.
        method play -> Done {
            element.play
        }

        // Pause the audio.
        method pause -> Done {
            element.pause
        }

        // Whether the audio will loop back to the start when it ends.
        method isLooping -> Boolean {
            element.loop
        }

        // Set whether audio loops back to start when it end
        method looping:= (value: Boolean) -> Done {
            element.loop:= value
        }

        // Whether the audio has finished playing.
        method isEnded -> Boolean {
            element.ended
        }

        // String representation of audio file
        method asString -> String {
            "audio from {source}"
        }
    }
}
