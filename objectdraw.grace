#pragma ExtendedLineups
dialect "none"
import "standardGrace" as sg
import "dom" as dom
import "random" as random
import "sys" as sys

inherit sg.methods

// ** Helpers ***************************************************

// The frame rate of the drawing.
def frameRate: Number = 30

method randomNumberFrom (m: Number) to (n: Number) -> Number {
    // A pseudo-random number in the interval [m..n)
    ((n - m) * random.between0And1) + m
}

method randomIntFrom (m: Number) to (n: Number) -> Number 
          is confidential {
    // A pseudo-random integer in the interval [m..n]
    random.integerIn (m) to (n) }

type Foreign = Unknown

def document: Foreign = dom.document

// ** Types ********************************************************************

// The super-type of all components in a GUI.
type Component = {

    // The underlying DOM element of the component.
    element

    // The width of this component.
    width -> Number

    // The height of this component.
    height -> Number

    // The size (width, height) of this component
    size -> Point

    // Respond to a mouse click (press and release) in this component with the
    // given event.
    onMouseClickDo (f: MouseResponse) -> Done

    // Respond to a mouse press in this component with the response f.
    onMousePressDo (f: MouseResponse) -> Done

    // Respond to a mouse release in this component with the response f.
    onMouseReleaseDo (f: MouseResponse) -> Done

    // Respond to a mouse move in this component with the response f.
    onMouseMoveDo (f: MouseResponse) -> Done

    // Respond to a mouse drag (move during press) in this component with the
    // response f.
    onMouseDragDo (f: MouseResponse) -> Done

    // Respond to a mouse entering this component with the response f.
    onMouseEnterDo (f: MouseResponse) -> Done

    // Respond to a mouse exiting this component with the response f.
    onMouseExitDo (f: MouseResponse) -> Done

    // Respond to a key type (press and release) in this component with the response f.
    onKeyTypeDo (f: KeyResponse) -> Done

    // Respond to a key press in this component with the response f.
    onKeyPressDo (f: KeyResponse) -> Done

    // Respond to a key release in this component with the response f.
    onKeyReleaseDo (f: KeyResponse) -> Done

    // Whether this component will dynamically fill up any empty space in the
    // direction of its parent container.
    isFlexible -> Boolean

    // Set whether this component will dynamically fill up any empty space in the
    // direction of its parent container.
    flexible := (value: Boolean) -> Done

}

// The type of components that contain other components.
type Container = Component & interface {

    // The number of components inside this container.
    size -> Number

    // Retrieve the component at the given index.
    at (index: Number) -> Component

    // Put the given component at the given index.
    at (index: Number) put(component: Component) -> Done

    // Add a component to the end of the container.
    append (component: Component) -> Done

    // Add a component to the start of the container.
    prepend (component: Component) -> Done

    // Perform an action for every component inside this container.
    do (f: Procedure1⟦Component⟧) -> Done

    // Arrange the contents of this container along the horizontal axis.
    // Components which exceed the width of the container will wrap around.
    arrangeHorizontal -> Done

    // Arrange the contents of this container along the vertical axis.
    // Components which exceed the height of the container will wrap around.
    arrangeVertical -> Done

}

// A standalone window which contains other components.
type Application = Container & interface {

    // The title of the application window.
    windowTitle -> String

    // Set the title of the application window.
    windowTitle:= (value: String) -> Done

    // Create window with listeners for mouse enter and exit actions
    startApplication -> Done

    // Close the window
    stopApplication -> Done
}

// Objects that can be drawn on a canvas and moved around.
type Graphic = {

    // The location of this object from the top-left corner of the screen.
    location -> Point

    // The horizontal location of this object from the top-left corner of the
    // screen.
    x -> Number

    // The vertical location of this object from the top-left corner of the
    // screen.
    y -> Number

    // Add this object to the given canvas.
    addToCanvas (canvas: DrawingCanvas) -> Done

    // Remove this object from its canvas.
    removeFromCanvas -> Done

    // Whether this object is currently set to be visible on the canvas.
    isVisible -> Boolean

    // Set whether this object is currently visible on the canvas.
    visible:= (value: Boolean) -> Done

    // Move this object to the given point on the canvas.
    moveTo(location: Point) -> Done

    // Move this object by the given distances on the canvas.
    moveBy(dx: Number, dy: Number) -> Done

    // Whether the given location is inside this object.
    contains(location: Point) -> Boolean

    // Whether any point in the given graphic is inside this object.
    overlaps(graphic: Graphic2D) -> Boolean

    // set the color of this object to c
    color := (c: Color)->Done

    // return the color of this object
    color -> Color

    // Send this object up one layer on the screen
    sendForward -> Done

    // send this object down one layer on the screen
    sendBackward -> Done

    // send this object to the top layer on the screen
    sendToFront -> Done

    // send this object to the bottom layer on the screen
    sendToBack -> Done
}


// DrawingCanvas holding graphic objects
type DrawingCanvas = Component & interface {

    // redraws the canvas and its contents regularly as needed
    startDrawing -> Done

    // add d to canvas
    add (d: Graphic)->Done

    // remove d from canvas
    remove (d: Graphic)->Done

    // Inform canvas that it needs to be redrawn
    notifyRedraw -> Done

    // clear the canvas
    clear -> Done

    // Send d to top layer of graphics
    sendToFront (d: Graphic) -> Done

    // send d to bottom layer of graphics
    sendToBack (d: Graphic) -> Done

    // send d up one layer in graphics
    sendForward (d: Graphic) -> Done

    // send d down one layer in graphics
    sendBackward (d: Graphic) -> Done

    // return the current dimensions of the canvas
    width -> Number
    height -> Number
    size -> Point
}

// Type of object that runs a graphical application that draws
// objects on a canvas included in the window and responds to mouse actions
type GraphicApplication = Application & interface {
    // canvas holds graphic objects on screen
    canvas -> DrawingCanvas

    // Respond to a mouse click (press and release) in the canvas at the given
    // point.
    onMouseClick (mouse: Point) -> Done

    // Respond to a mouse press in the canvas at the given point.
    onMousePress (mouse: Point) -> Done

    // Respond to a mouse release in the canvas at the given point.
    onMouseRelease (mouse: Point) -> Done

    // Respond to a mouse move in the canvas at the given point.
    onMouseMove (mouse: Point) -> Done

    // Respond to a mouse drag (move during press) in the canvas at the given
    // point.
    onMouseDrag (mouse: Point) -> Done

    // Respond to a mouse entering the canvas at the given point.
    onMouseEnter (mouse: Point) -> Done

    // Respond to a mouse exiting the canvas at the given point.
    onMouseExit (mouse: Point) -> Done

    // must be invoked to create window and its contents as well as prepare the
    // window to handle mouse events
    startGraphics -> Done
}

// Two-dimensional objects that can also be resized
type Graphic2D = Graphic & interface {

    // dimensions of object
    width -> Number
    height -> Number
    size -> Point

    // Change dimensions of object
    size := (dimensions: Point) -> Done
    width := (width: Number) -> Done
    height := (height: Number) -> Done
}

// One-dimensional objects
type Line = Graphic & interface {
    // start and end of line
    start -> Point
    end -> Point

    // set start and end of line
    start := (start': Point) -> Done
    end := (end': Point) -> Done
    setEndPoints (start': Point, end': Point) -> Done
}

// Text that can be drawn on a canvas.
type Text = Graphic & interface {

    // return the contents displayed in the item
    contents -> String

    // reset the contents displayed to be s
    contents := (s: String) -> Done

    // return width of text item (currently inaccurate)
    width -> Number

    // return size of the font used to display the contents
    fontSize -> Number

    // Set the size of the font used to display the contents
    fontSize := (size: Number) -> Done

}

// Component of window that holds text
type TextBox = Component & interface {

    // The text contents of the box.
    contents -> String
    contents:= (value: String) -> Done

}

// Component of window that holds text
type Labeled = Component & interface {

    // The label name.
    label -> String
    label:= (value: String) -> Done

}

// type of button component in window
type Button = Labeled

// Component that can take input and respond to an event
type Input = Component & interface {

    // Respond to this input gaining focus with the given event.
    onFocusDo(f: Response) -> Done

    // Respond to this input losing focus with the given event.
    onBlurDo(f: Response) -> Done

    // Respond to this input having its value changed.
    onChangeDo(f: Response) -> Done

}

// Component in window taking user text input
type TextField = Input & interface {

    // The contents of the text field.
    text -> String
    text := (value: String) -> Done

}

// Component in window taking user numeric input
type NumberField = Input & interface {

    // The contents of the number field.
    number -> Number
    number := (value: Number) -> Done

}

// Type for pop-up menus
type Choice = Input & interface {

    // The currently selected option.
    selected -> String
    selected := (value: String) -> Done

}

// ** Colors *******************************************************************
type Color = {
    red -> Number     // The red component of the color.
    green -> Number   // The green component of the color.
    blue -> Number    // The blue component of the color.
}

type ColorFactory = {
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

// Exception that may be thrown if the r, b, or g components
// are not between 0 and 255 (inclusive)
def ColorOutOfRange: prelude.ExceptionKind is public =
      prelude.ProgrammingError.refine "ColorOutOfRange"

// Simple color class
def colorGen is public = object {
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

        method asString -> String {
            "color w/ rgb({red}, {green}, {blue})"
        }
    }

    method random -> Color {
        // Produce a random color.
        r (randomIntFrom (0) to (255))
              g (randomIntFrom (0) to (255))
              b (randomIntFrom (0) to (255))
    }

    def white:Color is public = r (255) g (255) b (255)
    def black:Color is public = r (0) g (0) b (0)
    def green:Color is public = r (0) g (255) b (0)
    def red:Color is public = r (255) g (0) b (0)
    def gray:Color is public = r (60) g (60) b (60)
    def blue:Color is public = r (0) g (0) b (255)
    def cyan:Color is public = r (0) g (255) b (255)
    def magenta:Color is public = r (255) g (0) b (255)
    def yellow:Color is public = r (255) g (255) b (0)
    def neutral:Color is public = r (220) g (220) b (220)
}

// ** Events *******************************************************************

// Generic event containing source of the event.
type Event = {
    source -> Component
}

// Mouse event containing mouse location when event generated
type MouseEvent = Event & interface {
    at -> Point
}

// Type of an event associated with a key press
type KeyEvent = Event & interface {
    //character -> String
    code -> Number
    //modifiers -> Modifiers
}

// type of an action taking an Event as a paramter
type Response = Procedure1⟦Event⟧

// type of an action taking a MouseEvent as a parameter
type MouseResponse = Procedure1⟦MouseEvent⟧

// type of an action taking a KeyEvent as a parameter
type KeyResponse = Procedure1⟦KeyEvent⟧

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

// where T <: Component
type ComponentFactory⟦T⟧ = {

    // Build a component around an existing element.
    fromElement (element) -> T

    // Build a component around a new element of the given tag name.
    ofElementType (tagName: String) -> T
}


def maxClickTime: Number = 200
// The maximum number of milliseconds for which the mouse-button can be held
// down in order for the event to be registered as a click.


class componentFromElement (element') -> Component {
    def element is public = element'

    // width of component
    method width -> Number {
        element.width
    }

    // height of component
    method height -> Number {
        element.height
    }

    // dimensions of component
    method size -> Point {
        element.width @ element.height
    }

    method on(event': String)
          do(f: Procedure1⟦Foreign⟧) -> Done is confidential {
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

    // Associate action f to mouse press event
    method onMousePressDo (f: MouseResponse) -> Done {
        on "mousedown" withPointDo (f)
    }

    // Associate action f to mouse release event
    method onMouseReleaseDo (f: MouseResponse) -> Done {
        on "mouseup" withPointDo (f)
    }

    // Associate action f to mouse move event
    method onMouseMoveDo (f: MouseResponse) -> Done {
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

    // Associate action f to mouse drag event
    method onMouseDragDo (f: MouseResponse) -> Done {
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

    // Associate action f to mouse enter (of window) event
    method onMouseEnterDo (f: MouseResponse) -> Done {
        on "mouseover" do { event' ->
            def from = event'.relatedTarget
            if ((dom.noObject == from) || {!element.contains(from)}) then {
                f.apply (mouseEventSource (self) event (event'))
            }
        }
    }

    // Associate action f to mouse exit event
    method onMouseExitDo (f: MouseResponse) -> Done {
        on "mouseout" do {event' ->
            def to = event'.relatedTarget

            if ((dom.noObject == to) || {!element.contains (to)}) then {
                f.apply (mouseEventSource (self) event (event'))
            }
        }
    }

    // Associate action f to key event of kind
    method on (kind: String)
          withKeyDo (f: KeyResponse) -> Done is confidential {
        on (kind) do {event' ->
            f.apply (keyEventSource (self) event (event'))
        }
    }

    // Associate action f to key press event
    method onKeyPressDo(f: KeyResponse) -> Done {
        on "keydown" withKeyDo (f)
    }

    // Associate action f to key release event
    method onKeyReleaseDo (f: KeyResponse) -> Done {
        on "keyup" withKeyDo (f)
    }

    // Associate action f tokey type (press & release) event
    method onKeyTypeDo (f: KeyResponse) -> Done {
        on "keypress" withKeyDo (f)
    }

    // Does component have some flex in size
    method isFlexible -> Boolean {
        element.style.flexGrow.asNumber > 0
    }

    // Set whether component is flexibile
    method flexible:= (value: Boolean) -> Done {
        element.style.flexGrow := if (value) then {
            1
        } else {
            0
        }
    }

    // string representation of component
    method asString -> String {
        "a component"
    }
}

class componentOfElementType (tagName:String) -> Component {
    // Creates a component with type tagName

    inherit componentFromElement (document.createElement (tagName))

}


class containerOfElementType (tagName: String) -> Component {
    inherit containerFromElement (document.createElement (tagName))
}

// Create a new Component from element'
class containerFromElement (element') -> Container {
    inherit componentFromElement (element')

    def children = []

    // Number of children
    method size -> Number {
        children.size
    }

    // Is it empty?
    method isEmpty -> Boolean {
        size == 0
    }

    // Subcomponent at position index
    method at (index: Number) -> Component {
        // No point in checking bounds, since children.at will do so
        children.at (index)
    }

    // Replace subcomponent at index by aComponent
    method at (index: Number) put (aComponent: Component) -> Done {
        if ((index < 1) || (index > (size + 1))) then {
            prelude.BoundsError.raise
                "Can't put component at {index} because I have {size} elements"
        }

        if (index == (size + 1)) then {
            element.appendChild (aComponent.element)
        } else {
            element.insertBefore (aComponent.element, children.at (index).element)
        }

        children.at (index) put (aComponent)

        done
    }

    // Add aComponent after all existing components in the container
    method append (aComponent: Component) -> Done {
        element.appendChild (aComponent.element)

        children.push (aComponent)

        done
    }

    // Add aComponent before all existing components in the container
    method prepend (aComponent: Component) -> Done {
        if (isEmpty) then {
            element.appendChild (aComponent.element)
        } else {
            element.insertBefore (aComponent.element, element.firstChild)
        }

        children.unshift (aComponent)

        done
    }

    // Apply f to all children of container.
    method do (f: Procedure1⟦Component⟧) -> Done {
        for (children) do {aComponent: Component ->
            f.apply(aComponent)
        }
    }

    // Generalize binary function f to apply to all children of container.
    // Value if no children is initial
    method fold⟦T⟧(f: Function2⟦T, Component, T⟧)
          startingWith (initial: T) -> T {
        var value: T:= initial

        for (children) do {aComponent: Component ->
            value:= f.apply (value, aComponent)
        }

        value
    }

    // Make container more flexible
    method flex -> Done is confidential {
        element.style.display := "inline-flex"
        element.style.justifyContent := "center"
        element.style.flexFlow := "row wrap"
    }

    // Arrange elements in rows
    method arrangeHorizontal -> Done {
        flex
        element.style.flexDirection:= "row"
    }

    // Arrange elements in columns
    method arrangeVertical -> Done {
        flex
        element.style.flexDirection := "column"
    }

    // return description of container
    method asString -> String {
        "container: with {size} children"
    }
}

// Create an empty container ready to add in row
class emptyContainer -> Container {
    inherit containerOfElementType ("div")

    self.arrangeHorizontal
}

// Set empty container with given width' and height'
class containerSize (width': Number, height': Number) -> Container {
    inherit emptyContainer

    self.element.style.width:= "{width'}px"
    self.element.style.height:= "{height'}px"
    self.element.style.overflow:= "auto"

}

// A factory building components that take input
class inputFromElement (element') -> Input {
    inherit componentFromElement(element')

    // Respond with action f to this input gaining focus with the given event.
    method onFocusDo (f: Response) -> Done {
        element.addEventListener ("focus", { _ ->
            f.apply(eventSource(self))
        })
    }

    // Respond with action f to this input losing focus with the given event.
    method onBlurDo (f: Response) -> Done {
        element.addEventListener("blur", { _ ->
            f.apply(eventSource(self))
        })
    }

    // Respond with action f to this input having its value changed.
    method onChangeDo (f: Response) -> Done {
        element.addEventListener ("change", { _ ->
            f.apply(eventSource(self))
        })
    }

    // return description of component
    method asString -> String {
        "an input"
    }
}

// Create component of type elementType to handle input
class inputOfElementType(elementType: String) -> Input {
    inherit inputFromElement (document.createElement (elementType))
}

// Create component of type inputType to handle input
class inputOfType (inputType: String) -> Input {
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

// Log entry to keep take of response to an event
class eventLogKind(kind': String)
      response(response': Procedure0) is confidential {
    def kind: String is public = kind'
    def response: Procedure0 is public = response'
}

class applicationTitle(initialTitle: String)
      size (dimensions': Point) -> Application {
    // Create an application with window titled initialTitle and
    // size dimensions'

    inherit containerFromElement(document.createDocumentFragment)
        alias containerElement = element
        alias containerArrangeHorizontal = arrangeHorizontal
        alias containerArrangeVertical = arrangeVertical

    var isOpened: Boolean:= false  // whether window is visible
    var theWindow: Foreign

    var theTitle: String:= initialTitle
    var theWidth: Number:= dimensions'.x
    var theHeight: Number:= dimensions'.y

    def events = []

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
    // Components which exceed the width of the container will wrap around.
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
            if (prelude.inBrowser && (dom.noObject == theWindow)) then {
                print "Failed to open the graphics window.\nIs your browser blocking pop-ups?"
                sys.exit(1)
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

            for (events) do { anEvent ->
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

    // list of all objects on canvas (hidden or not)
    var theGraphics:= [ ] // emptyList

    var redraw: Boolean:= false

    // Inform canvas that it needs to be redrawn
    method notifyRedraw -> Done {
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
        theGraphics:= []
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
        for (theGraphics) do { aGraphic ->
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
    method contains (locn: Point) -> Boolean {
        prelude.SubobjectResponsibility.raise "`contains(_)` not implemented by {self}"
    }

    // Determine whether this object overlaps otherObject
    method overlaps (otherObject: Graphic2D) -> Boolean {
        prelude.SubobjectResponsibility.raise "`overlaps(_)` not implemented by {self}"
    }

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
    method draw (ctx: Foreign) -> Done {
        prelude.SubobjectResponsibility.raise "`draw(_)` not implemented by {self}"
    }

    // Return a string representation of the object
    method asString -> String {
        "Graphic object"
    }
}


class drawable2DAt (location': Point)
      size (dimension': Point)
      on (canvas': DrawingCanvas) -> Graphic {
    // abstract class for two-dimensional objects

    inherit drawableAt (location') on (canvas')
    var theWidth: Number:= dimension'.x

    // Width of the object
    method width -> Number {theWidth}
    var theHeight: Number:= dimension'.y

    // Height of the object
    method height -> Number {theHeight}

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

    // Draw filled oval on canvas
    method draw (ctx: Foreign) -> Done {
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

    // string representation of oval
    method asString -> String {
        "FilledOval at ({x},{y}) "++
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

    // Draw framed arc
    method draw (ctx: Foreign) -> Done {
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

    // String representation of framed arc
    method asString -> String {
        "FramedArc at ({x},{y}) "++
              "with height {height}, width {width}, and color {self.color} going "++
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

    // Draw filled arc on canvas
    method draw (ctx: Foreign) -> Done {
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

    // String representation of filled arc
    method asString -> String {
        "FilledArc at ({x},{y}) "++
              "with height {height}, width {width}, and color {self.color} going "++
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

// Type of factory for creating line segments
//type LineFactory = {
    //
    //    from (start:Point) to (end:Point) on (canvas: DrawingCanvas) -> Line
    //    // Creates a line from start to end on canvas
    //
    //    from (pt:Point) length (len:Number) direction (radians:Number)
    //          on (canvas:DrawingCanvas) -> Line
    //    // Creates a line from pt, of length len, in direction radians, on canvas
    //}


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

// Generate an unlabeled password field
class passwordFieldUnlabeled -> TextField {
    inherit passwordFieldLabeled ""
}

class numberFieldLabeled (label': String) -> NumberField {
    // Generates a number field with initial contents label'

    inherit fieldOfType("number") labeled (label')

    // Return the number in the field
    method number -> Number {
        self.element.value.asNumber
    }

    // update the number in the field
    method number:= (value: Number) -> Done {
        self.element.value:= value
    }

    // Return description of the number field
    method asString -> String {
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

class menuWithOptions(options:Iterable⟦String⟧) labeled (label':String)
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

    for (options) do { name: String ->
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

class menuWithOptions (options: Iterable⟦String⟧) -> Choice {
    // Creates choice box with list of items from options
    // Initially shows first item in options
    inherit menuWithOptions (options) labeled ""
    self.element.removeChild (self.labelElement)

}


type Audio = {
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
