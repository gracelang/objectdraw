#pragma PrimitiveLists
#pragma noTypeChecks
inherits _prelude.methods

import "dom" as dom
import "math" as math


// ** Helpers ***************************************************

// The frame rate of the drawing.
def frameRate: Number = 30

// A random number from m to n, inclusive.
method randomNumberFrom (m: Number) to (n: Number) -> Number {
    ((n - m) * math.random) + m
}

// A random integer from m to n, inclusive.
method randomIntFrom (m: Number) to (n: Number) -> Number {
    (((n - m + 1) * math.random).truncated % (n - m + 1)) + m
}

// A rough approximation of the value of pi.
def pi: Number is public = π

type Foreign = Unknown

def document: Foreign = dom.document

// Types of blocks representing functions taking an argument of type T
// and returning a value of type R
type Function<T, R> = prelude.Block1<T,R>

// Types of blocks representing functions taking two arguments of type T and U
// and returning a value of type R
type Function2<T, U, R> = prelude.Block2<T, U, R>

// Type of block taking argument of type T and returning Done
type Procedure<T> = prelude.Block1<T,Done>

// ** Types ********************************************************************

// The super-type of all components in a GUI.
type Component = {

    // The underlying DOM element of the component.
    element

    // The width of this component.
    width -> Number

    // The height of this component.
    height -> Number

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
type Container = Component & type {

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
    do (f: Procedure<Component>) -> Done

    // Arrange the contents of this container along the horizontal axis.
    // Components which exceed the width of the container will wrap around.
    arrangeHorizontal -> Done

    // Arrange the contents of this container along the vertical axis.
    // Components which exceed the height of the container will wrap around.
    arrangeVertical -> Done

}

// A standalone window which contains other components.
type Application = Container & type {

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
type DrawingCanvas = Component & type {

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

}

// Type of object that runs a graphical application that draws
// objects on a canvas included in the window and responds to mouse actions
type GraphicApplication = Application & type {
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
type Graphic2D = Graphic & type {

    // dimensions of object
    width -> Number
    height -> Number

    // Change dimensions of object
    setSize (width: Number, height: Number) -> Done
    width := (width: Number) -> Done
    height := (height: Number) -> Done
}

// One-dimensional objects
type Line = Graphic & type {
    // start and end of line
    start -> Point
    end -> Point

    // set start and end of line
    start := (start': Point) -> Done
    end := (end': Point) -> Done
    setEndPoints (start': Point, end': Point) -> Done
}

// Text that can be drawn on a canvas.
type Text = Graphic & type {

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
type TextBox = Component & type {

    // The text contents of the box.
    contents -> String
    contents:= (value: String) -> Done

}

// Component of window that holds text
type Labeled = Component & type {

    // The label name.
    label -> String
    label:= (value: String) -> Done

}

// type of button component in window
type Button = Labeled

// Component that can take input and respond to an event
type Input = Labeled & type {

    // Respond to this input gaining focus with the given event.
    onFocusDo(f: Response) -> Done

    // Respond to this input losing focus with the given event.
    onBlurDo(f: Response) -> Done

    // Respond to this input having its value changed.
    onChangeDo(f: Response) -> Done

}

// Component in window taking user text input
type TextField = Input & type {

    // The contents of the text field.
    text -> String
    text := (value: String) -> Done

}

// Component in window taking user numeric input
type NumberField = Input & type {

    // The contents of the number field.
    number -> Number
    number := (value: Number) -> Done

}

// Type for pop-up menus
type Choice = Input & type {

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

// Exception that may be thrown if the r, b, or g components
// are not between 0 and 255 (inclusive)
def ColorOutOfRange: prelude.ExceptionKind is public =
    ProgrammingError.refine "Color Out Of Range"

// Simple color class
def color is public = object {
    class r (r': Number) g (g': Number) b (b': Number) -> Color {
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

        def red:Number is public = r'.truncate
        def green:Number is public = g'.truncate
        def blue:Number is public = b'.truncate

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

// Predefined colors.  Deprecated: use color.white, etc.
def white:Color is public = color.r (255) g (255) b (255)
def black:Color is public = color.r (0) g (0) b (0)
def green:Color is public = color.r (0) g (255) b (0)
def red:Color is public = color.r (255) g (0) b (0)
def gray:Color is public = color.r (60) g (60) b (60)
def blue:Color is public = color.r (0) g (0) b (255)
def cyan:Color is public = color.r (0) g (255) b (255)
def magenta:Color is public = color.r (255) g (0) b (255)
def yellow:Color is public = color.r (255) g (255) b (0)
def neutral:Color is public = color.r (220) g (220) b (220)

// A random color.  Deprecated: use color.random
method randomColor -> Color { color.random }

// ** Events *******************************************************************

// Generic event containing source of the event.
type Event = {
    source -> Component
}

// Mouse event containing mouse location when event generated
type MouseEvent = Event & type {
    at -> Point
}

// Type of an event associated with a key press
type KeyEvent = Event & type {
    //character -> String
    code -> Number
    //modifiers -> Modifiers
}

// type of an action taking an Event as a paramter
type Response = Procedure<Event>

// type of an action taking a MouseEvent as a parameter
type MouseResponse = Procedure<MouseEvent>

// type of an action taking a KeyEvent as a parameter
type KeyResponse = Procedure<KeyEvent>

def event is public = object {
    class source (source':Component) -> Event {
        // Creates an event generated by source'

        def source: Component is public = source'

        method asString -> String {
            "Event on {source}"
        }
    }
}

def mouseEvent is public = object {
    class source (source':Component) event (event':Foreign) -> MouseEvent {
        // Creates a mouseEvent with the mouse location from event'

        inherits event.source (source')
        def at: Point is public = (event'.pageX - source.element.offsetLeft) @
            (event'.pageY - source.element.offsetTop)

        // String representation of the mouse event
        method asString -> String {
            "Mouse event on {source} at {at}"
        }
    }
}

def keyEvent is public = object {
    class source (source':Component) event(event':Foreign) -> KeyEvent {
        // Creates an event with the key-code from event'
        inherits event.source(source')
        def code: Number is public = event'.which
        //def character is public = dom.window.String.fromCharCode(event'.which)

        // String representation of the key event
        method asString -> String {
            "Event on {source} for key-code {code}"
        }
    }
}


// ** Internal factories *******************************************************

// where T <: Component
type ComponentFactory<T> = {

    // Build a component around an existing element.
    fromElement (element) -> T

    // Build a component around a new element of the given tag name.
    ofElementType (tagName: String) -> T
}


def maxClickTime: Number = 200
// The maximum number of milliseconds for which the mouse-button can be held
// down in order for the event to be registered as a click.


def component: ComponentFactory<Component> = object {
    // Factory object for components that respond to mouse actions

    class fromElement (element') -> Component {
        def element is public = element'

        // width of component
        method width -> Number {
            element.width
        }

        // height of component
        method height -> Number {
            element.height
        }

        // assocate action f with event' on component
        method on(event': String)
              do(f: Procedure<Foreign>) -> Done is confidential {
            element.addEventListener(event', f)
            done
        }

        // associate response f to mouse event of kind
        method on (kind: String)
              withPointDo (f:MouseResponse) -> Done is confidential {
            on (kind) do { event' ->
                f.apply (mouseEvent.source (self) event (event'))
            }
        }

        method onMouseClickDo (f:MouseResponse) -> Done {
            // Associates action f with mouse click event
            var lastDown: Foreign

            on "mousedown" do {event': Foreign ->
                lastDown:= event'.timeStamp
            }

            on "click" do {event': Foreign ->
                if ((event'.timeStamp - lastDown) <= maxClickTime) then {
                    f.apply (mouseEvent.source(self) event(event'))
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
                    f.apply(mouseEvent.source (self) event (event'))
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
                    f.apply(mouseEvent.source (self) event(event'))
                }
            }
        }

        // Associate action f to mouse enter (of window) event
        method onMouseEnterDo (f: MouseResponse) -> Done {
            on "mouseover" do { event' ->
                def from = event'.relatedTarget

                if ((from == dom.noObject).orElse {!element.contains(from)}) then {
                    f.apply (mouseEvent.source (self) event (event'))
                }
            }
        }

        // Associate action f to mouse exit event
        method onMouseExitDo (f: MouseResponse) -> Done {
            on "mouseout" do {event' ->
                def to = event'.relatedTarget

                if ((to == dom.noObject).orElse {!element.contains (to)}) then {
                    f.apply (mouseEvent.source (self) event (event'))
                }
            }
        }

        // Associate action f to key event of kind
        method on (kind: String)
              withKeyDo (f: KeyResponse) -> Done is confidential {
            on (kind) do {event' ->
                f.apply (keyEvent.source (self) event (event'))
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

    class ofElementType (tagName:String) -> Component {
        // Creates a component with type tagName

        inherits fromElement (document.createElement (tagName))
    }
}


def container: ComponentFactory<Container> is public = object {
    // A factory object for containers

    // Create a new Component with name tagName
    class ofElementType (tagName: String) -> Component {
        inherits fromElement (document.createElement (tagName))
    }

    // Create a new Component from element'
    class fromElement (element') -> Container {
        inherits component.fromElement (element')

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
            if ((index < 1) || (index > size)) then {
                collections.BoundsError.raiseForIndex (index)
            }

            children.at (index)
        }

        // Replace subcomponent at index by aComponent
        method at (index: Number) put (aComponent: Component) -> Done {
            if ((index < 1) || (index > (size + 1))) then {
                BoundsError.raiseForIndex (index)
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
        method do (f: Procedure<Component>) -> Done {
            for (children) do {aComponent: Component ->
                f.apply(aComponent)
            }
        }

        // Generalize binary function f to apply to all children of container.
        // Value if no children is initial
        method fold<T>(f: Function2<T, Component, T>)
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
    class empty -> Container {
        inherits ofElementType ("div")

        self.arrangeHorizontal
    }

    // Set empty container with given width' and height'
    class size (width': Number, height': Number) -> Container {
        inherits empty

        self.element.style.width:= "{width'}px"
        self.element.style.height:= "{height'}px"
        self.element.style.overflow:= "auto"
    }
}

// A factory building componets that take input
def input: ComponentFactory<Input> = object {

    class fromElement (element') -> Input {
        inherits component.fromElement(element')

        // Respond with action f to this input gaining focus with the given event.
        method onFocusDo (f: Response) -> Done {
            element.addEventListener ("focus", { _ ->
                f.apply (event.source (self))
            })
        }

        // Respond with action f to this input losing focus with the given event.
        method onBlurDo (f: Response) -> Done {
            element.addEventListener("blur", { _ ->
                f.apply(event.source(self))
            })
        }

        // Respond with action f to this input having its value changed.
        method onChangeDo (f: Response) -> Done {
            element.addEventListener ("change", { _ ->
                f.apply(event.source(self))
            })
        }

        // return description of component
        method asString -> String {
            "an input"
        }
    }

    // Create component of type elementType to handle input
    class ofElementType(elementType: String) -> Input {
        inherits fromElement (document.createElement (elementType))
    }

    // Create component of type inputType to handle input
    class ofType (inputType: String) -> Input {
        inherits ofElementType("input")

        self.element.setAttribute ("type", inputType)
    }
}

def labeledWidget:ComponentFactory<Labeled> = object {
    // Factory object for create labeled components

    class fromElement (element') -> Labeled {
        // create labeled input from element'

        inherits input.fromElement (element')

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

    method ofElementType (elementType:String) -> Labeled {
        // creates labeled input a new document of elementType

        fromElement (document.createElement (elementType))
    }

    method ofElementType (elementType: String)
          labeled(label: String) -> Labeled {
        // Create labeled element from elementType with label
        def result = ofElementType(elementType)
        result.label := label
        result
    }
}

def field is public = object {
    class ofType(inputType: String) labeled(label': String) -> Input {
        // Create input field of type inputType showing label'

        inherits input.ofType(inputType)

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
}


// ** External factories *******************************************************

// Log entry to keep take of response to an event
class eventLogKind(kind': String)
      response(response': Procedure) is confidential {
    def kind: String is public = kind'
    def response: Procedure is public = response'
}

def application is public = object {
    class title(initialTitle: String)
          size(initialWidth: Number, initialHeight: Number) -> Application {
        // Create an application with window titled initialTitle and
        // size initialWidth x initialHeight

        inherits container.fromElement(document.createDocumentFragment)

        var isOpened: Boolean:= false  // whether window is visible
        var theWindow: Foreign

        var theTitle: String:= initialTitle
        var theWidth: Number:= initialWidth
        var theHeight: Number:= initialHeight

        def events = []

        method element -> Foreign {
            if (isOpened) then {
                theWindow.document.body
            } else {
                super.element
            }
        }

        // Whether new items are added to window from left to right or top to bottom
        var isHorizontal: Boolean:= true

        // Arrange the contents of this container along the horizontal axis.
        // Components which exceed the width of the container will wrap around.
        method arrangeHorizontal -> Done {
            if (isOpened) then {
                super.arrangeHorizontal
            } else {
                isHorizontal:= true
            }
        }

        // Arrange the contents of this container along the vertical axis.
        // Components which exceed the height of the container will wrap around.
        method arrangeVertical -> Done {
            if (isOpened) then {
                super.arrangeVertical
            } else {
                isHorizontal:= false
            }
        }

        // Associate response with event kind
        method on (kind: String)
              do (response: Procedure<Event>) -> Done is confidential {
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

                if (from == dom.noObject) then {
                    f.apply(mouseEvent.source(self) event(event'))
                }
            }
        }

        // Respond to a mouse exiting this window with the response f.
        method onMouseExitDo(f: MouseResponse) -> Done {
            on "mouseout" do { event' ->
                def to = event'.relatedTarget

                if (to == dom.noObject) then {
                    f.apply(mouseEvent.source(self) event(event'))
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
}

def drawingCanvas is public = object {
    class size(width': Number, height': Number) -> DrawingCanvas {
        // class representing a window panel that manages graphics on screen
        // The window containing the canvas has dimensions width' x height'

        inherits component.fromElement(document.createElement("canvas"))

        element.width:= width'
        element.height:= height'
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

        // list of all objects on canvas (hidden or not)
        var theGraphics:= []

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
            theGraphics.remove (aGraphic)
            notifyRedraw
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
}

def graphicApplication is public = object {
    class size (theWidth':Number, theHeight':Number) -> GraphicApplication {
        // Create window with dimensions theWidth' x theHeight, with canvas
        // installed, and that responds to mouse actions

        inherits application.title ("Simple graphics") size (theWidth', theHeight')

        def canvas: DrawingCanvas is public = drawingCanvas.size (theWidth, theHeight)

        children.push (canvas)

        def before: Container = container.empty
        def after: Container = container.empty

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
            parentElement.style.width := "{theWidth}px"
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
}

def drawable is public = object {
    class at (location':Point) on (canvas':DrawingCanvas) -> Graphic {
        // abstract superclass for drawable objects (of type Graphic)

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

        // The canvas this object is part of
        var canvas: DrawingCanvas := canvas'

        // the color of this object
        var theColor: Color:= black

        method color -> Color {theColor}

        method color:= (newColor: Color) -> Done {
            theColor:= newColor
            notifyRedraw
        }

        var theFrameColor: Color := black

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
            SubobjectResponsibility.raise "contains not implemented for {self}"
        }

        // Determine whether this object overlaps otherObject
        method overlaps (otherObject: Graphic2D) -> Boolean {
            SubobjectResponsibility.raise "overlaps not implemented for {self}"
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
            SubobjectResponsibility.raise "draw not implemented for {self}"
        }

        // Return a string representation of the object
        method asString -> String {
            "Graphic object"
        }
    }
}


def drawable2D is public = object {
    class at (location': Point)
          size (width': Number, height': Number)
          on (canvas': DrawingCanvas) -> Graphic2D {
        // abstract class for two-dimensional objects

        inherits drawable.at (location') on (canvas')
        var theWidth: Number:= width'

        // Width of the object
        method width -> Number {theWidth}
        var theHeight: Number:= height'

        // Height of the object
        method height -> Number {theHeight}

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
                  "with height {height}, width {width}, and color {color}"
        }
    }
}

def resizable2D is public = object {
    class at (location': Point) size (width': Number, height': Number)
          on (canvas': DrawingCanvas) -> Graphic2D {
        // abstract class for 2 dimensional objects that can be resized.

        inherits drawable2D.at (location') size (width', height') on (canvas')

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
        method setSize (w: Number, h: Number) -> Done {
            width := w
            height := h
        }

        // Return string representation of object
        method asString -> String {
            "Resizable2D object at ({x},{y}) "++
                  "with height {height}, width {width}, and color {color}"
        }
    }

}

def framedRect is public = object {
    class at (location': Point) size (width': Number, height': Number)
          on (canvas': DrawingCanvas) -> Graphic2D {
        // class to generate framed rectangle at (x',y') with size width' x height'
        // created on canvas'

        inherits resizable2D.at (location') size (width', height') on (canvas')
        addToCanvas (canvas')

        // Draw the framed rectangle on the canvas
        method draw (ctx: Foreign) -> Done {
            ctx.save
            ctx.strokeStyle:= "rgb({color.red}, {color.green}, {color.blue})"
            ctx.strokeRect (x, y, width, height)
            ctx.restore
        }

        // Return description of framed rectangle
        method asString -> String {
            "FramedRect at ({x},{y}) "++
                  "with height {height}, width {width}, and color {color}"
        }
    }
}

def filledRect is public = object {
    class at (location': Point) size (width': Number, height': Number)
          on (canvas': DrawingCanvas) -> Graphic2D {
          
        // class to generate filled rectangle at (x', y') with size width' x height'
        // created on canvas'
        inherits resizable2D.at (location') size (width', height') on (canvas')

        addToCanvas (canvas')

        // Draw filled rectangle on the canvas
        method draw (ctx: Foreign) -> Done {
            ctx.save
            ctx.fillStyle:= "rgb({color.red}, {color.green}, {color.blue})"
            ctx.fillRect (x, y, width, height)
            ctx.restore
        }

        // Return string representation of the filled rectangle
        method asString -> String {
            "FilledRect at ({x}, {y}) "++
                  "with height {height}, width {width}, and color {color}"
        }
    }

}


def framedOval is public = object {
    class at (location': Point) size (width': Number, height': Number)
          on (canvas': DrawingCanvas) -> Graphic2D {
        // class to generate framed oval at (x',y') with size width' x height'
        // created on canvas'

        inherits resizable2D.at (location') size (width', height') on (canvas')
        addToCanvas (canvas')

        // draw framed oval on canvas
        method draw (ctx: Foreign) -> Done {
            ctx.beginPath
            ctx.save
            ctx.translate (x + width / 2, y + height / 2)
            ctx.scale (width / 2, height / 2)
            ctx.arc (0, 0, 1, 0, 2 * pi)
            ctx.restore
            ctx.save
            ctx.strokeStyle := "rgb({color.red}, {color.green}, {color.blue})"
            ctx.stroke
            ctx.restore
            ctx.closePath
        }

        // string representation of oval
        method asString -> String {
            "FramedOval at ({x},{y}) "++
                  "with height {height}, width {width}, and color {color}"
        }
    }

}

def filledOval is public = object {
    class at (location': Point) size (width': Number, height': Number)
          on (canvas': DrawingCanvas) -> Graphic2D {
        // class to generate filled oval at (x',y') with size width' x height'
        // created on canvas'

        inherits resizable2D.at (location') size (width', height') on (canvas')

        addToCanvas (canvas')

        // Draw filled oval on canvas
        method draw (ctx: Foreign) -> Done {
            ctx.beginPath
            ctx.save
            ctx.translate (x + width / 2, y + height / 2)
            ctx.scale (width / 2, height / 2)
            ctx.arc (0, 0, 1, 0, 2*pi)
            ctx.restore
            ctx.save
            ctx.fillStyle:= "rgb({color.red}, {color.green}, {color.blue})"
            ctx.fill
            ctx.restore
            ctx.closePath
        }

        // string representation of oval
        method asString -> String {
            "FilledOval at ({x},{y}) "++
                  "with height {height}, width {width}, and color {color}"
        }

    }
}

def framedArc is public = object {
    class at (location': Point) size (width': Number, height': Number)
          from (startAngle: Number) to (endAngle: Number)
          on (canvas': DrawingCanvas) -> Graphic2D {
        // class to generate framed arc at (x',y') with size width' x height'
        // from startAngle radians to endAngle radians created on canvas'
        // Note that angle 0 is in direction of positive x axis and increases in
        // angles go clockwise.
        inherits resizable2D.at (location') size (width', height') on (canvas')
        addToCanvas (canvas')

        // Draw framed arc
        method draw (ctx: Foreign) -> Done {
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
            ctx.strokeStyle:= "rgb({color.red}, {color.green}, {color.blue})"
            ctx.stroke
            ctx.restore
            ctx.closePath
        }

        // String representation of framed arc
        method asString -> String {
            "FramedArc at ({x},{y}) "++
                  "with height {height}, width {width}, and color {color} going "++
                  "from {startAngle} degrees to {endAngle} degrees"
        }
    }
}


def filledArc is public = object {
    class at (location': Point) size (width': Number, height': Number)
          from (startAngle: Number) to (endAngle: Number)
          on (canvas': DrawingCanvas) -> Graphic2D {
        // class to generate filled arc at (x',y') with size width' x height'
        // from startAngle degrees to endAngle degrees created on canvas'
        // Note that angle 0 is in direction of positive x axis and increases in
        // angles go clockwise.

        inherits resizable2D.at (location') size (width', height') on (canvas')
        addToCanvas (canvas')

        // Draw filled arc on canvas
        method draw (ctx: Foreign) -> Done {
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
            ctx.fillStyle:= "rgb({color.red}, {color.green}, {color.blue})"
            ctx.fill
            ctx.save
            ctx.closePath
        }

        // String representation of filled arc
        method asString -> String {
            "FilledArc at ({x},{y}) "++
                  "with height {height}, width {width}, and color {color} going "++
                  "from {startAngle} degrees to {endAngle} degrees"
        }

    }
}


type DrawableImageFactory = {
    // type of factory for creating images on canvas

    //at(location: Point) size(width: Number, height: Number)
          //file(fileName: String) on (canvas: DrawingCanvas) -> Graphic2D

    at (location: Point) size (width: Number, height: Number)
          url (url: String) on (canvas: DrawingCanvas) -> Graphic2D
}

def drawableImage: DrawableImageFactory is public = object {

//  class at(location': Point)   // doesn't work - can't find image?
//      size(width': Number, height': Number)
//      file(fileName: String)
//      on(canvas': DrawingCanvas) -> Graphic2D {
//    // class to generate an image on canvas' at location' with size width' x height'
//    // The image is taken from the file fileName and must be in "png" format.
//
//    inherits resizable2D.at(location')size(width',height')on(canvas')
//
//    if (!dom.window.graceHasFile(fileName)) then {
//      NoSuchFile.raise "The file '{fileName}' could not be found"
//    }
//
//    def theImage = dom.document.createElement("img")
//    theImage.src:= dom.window.graceReadFile(fileName)
//
//    method draw(ctx: Foreign) -> Done {
//      ctx.drawImage(theImage, x, y, width, height)
//    }
//
//    method asString -> String {
//      "DrawableImage at ({x},{y}) "++
//           "with height {height}, width {width}, "++
//           "from file {fileName}"
//    }
//
//    addToCanvas(canvas')
//  }


    class at(location': Point)
          size(width': Number, height': Number)
          url(url: String)
          on(canvas': DrawingCanvas) -> Graphic2D {
        // Creates image from url and places on
        // canvas' at location' with size width' x height'

        inherits resizable2D.at(location')size(width',height')on(canvas')

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
}

// Type of factory for creating line segments
type LineFactory = {

    from (start:Point) to (end:Point) on (canvas: DrawingCanvas) -> Line
    // Creates a line from start to end on canvas

    from (pt:Point) length (len:Number) direction (radians:Number)
          on (canvas:DrawingCanvas) -> Line
    // Creates a line from pt, of length len, in direction radians, on canvas
}


def line: LineFactory is public = object {
    // Factory for creating line segments

    class from (start': Point) to (end': Point)
          on (canvas': DrawingCanvas) -> Line {
        // Create a line from start' to end' on canvas'
        inherits drawable.at (start') on (canvas')

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
            ctx.save
            ctx.strokeStyle:= "rgb({color.red}, {color.green}, {color.blue})"
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
            math.sqrt (distToSegmentSquared (p, v, w))
        }

        method contains(pt:Point) -> Boolean {
            // Answers whether the line contains pt.  Returns true if pt is within
            // 2 pixels of the line

            def tolerance: Number = 2
            distToSegment(pt,start,end) < tolerance
        }

        method asString -> String {
            // Answers a string representation of this line
            "Line from {start} to {end} with color {color}"
        }
    }

    method from (pt: Point) length (len: Number) direction(radians: Number)
          on(canvas':DrawingCanvas) -> Line {
        // Creates a line from pt that has length len, and in direction radians on canvas'

        def endpt = pt + ((len * math.cos (radians)) @ (-len * math.sin (radians)))
        line.from (pt) to (endpt) on (canvas')
    }
}

def text is public = object {
    class at (location': Point) with (contents': String)
          on(canvas': DrawingCanvas) -> Text {
        // class to generate text at location' on canvas' initially showing
        // contents'
        inherits drawable.at (location') on (canvas')

        var theContents: String:= contents'
        var fsize: Number is readable:= 10

        // Return approximation of the width of the text
        method width -> Number {
            theContents.size * fsize / 2
        }

        // Draw the text
        method draw(ctx: Foreign) -> Done {
            ctx.save
            ctx.font:= "{fontSize}pt sans-serif"
            ctx.fillStyle:= "rgb({color.red}, {color.green}, {color.blue})"
            ctx.fillText (contents, location.x, location.y)
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
            "Text at ({x},{y}) with value {contents} and color {color}"
        }

        addToCanvas(canvas')
    }
}

def textBox is public = object {
    class with (contents': String) -> TextBox {
        // Create a component in window that holds the string contents'
        // It cannot respond to user actions

        inherits component.ofElementType ("span")

        // Return string contents of the text box
        method contents -> String {
            self.element.textContent
        }

        // Reset the contents of the text box
        method contents:= (value: String) -> Done {
            self.element.textContent:= value
            done
        }

        // Text representation of the text box
        method asString -> String {
            "a text box showing {contents}"
        }

        contents:= contents'
    }
}

def button is public = object {
    class labeled (label': String) -> Button {
        // Creates a button with label'
        inherits labeledWidget.ofElementType ("button") labeled (label')

        method asString -> String {
            "a button labeled: {self.label}"
        }
    }
}


type FieldFactory = {
    // Type of object that generates text fields
    // Text fields can respond to user actions

    labeled (label: String) -> Input
    // Generates text field with initial contents given by label

    unlabeled -> Input
    // Generates text field with no initial contents
}


def textField: FieldFactory is public = object {
    // Factory object for generate text fields

    class labeled (label':String) -> TextField {
        // Generates a text field with label'

        inherits field.ofType ("text") labeled (label')

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

    class unlabeled -> TextField {
        // Generates a text field without initial contents

        inherits labeled ""
    }
}


def passwordField: FieldFactory is public = object {
    // Factory object for fields to hold passwords

    class labeled (lab: String) -> Input {
        // Generates password field with initial contents lab

        inherits textField.labeled (lab)

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
    class unlabeled -> TextField {
        inherits labeled ""
    }

    // Return string representation of the password field
    method asString -> String {
        "passwordField"
    }
}


def numberField:FieldFactory is public = object {
    // Factory object for fields holding numbers

    class labeled (label': String) -> NumberField {
        // Generates a number field with initial contents label'

        inherits field.ofType("number") labeled (label')

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

    class unlabeled -> NumberField {
        // Creates an unlabeled number field
        inherits labeled ""
    }

    method asString -> String {
        // Describes this factory
        "numberField factory"
    }
}


type ChoiceFactory = {
    // Type of factory to generate choice boxes (pop-up menus)
    
    optionsFrom (options: Iterable<String>) -> Choice
    // Creates choice box with items from options;
    // initially shows first item in options

    options(*options: String) labeled(label: String) -> Choice
    // Creates choice item initialized with options initially showing label

    options(*options: String) -> Choice
    // Creates choice item initialized with options initially showing first item
}

def selectBox: ChoiceFactory is public = object {
    // Factory object for choice boxes (pop-up menus)

    method optionsFrom(options:Sequence<String>) labeled (label':String)
          -> Choice is confidential {
        // Creates choice box with list of items from options; initially shows label'

        def labeler:Foreign = document.createElement("option")
        labeler.value:= ""

        object {
            inherits labeledWidget.ofElementType("select") labeled(label')

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

            // Return string representation of select box
            method asString -> String {
                if (self.label == "") then {
                    "a select box"
                } else {
                    "a select box labeled: {self.label}"
                }
            }
        }
    }

    method options (*options: String) labeled (label': String) -> Choice {
        // Creates choice box with items from options
        // When created shows label'
        optionsFrom (options) labeled (label')
    }

    method optionsFrom (options: Sequence<String>) -> Choice {
        // Creates choice box with list of items from options
        // Initially shows first item in options
        def result = optionsFrom (options) labeled ""
        result.element.removeChild (result.labelElement)
        result
    }

    method options(*optStrings: String) -> Choice {
        // Creates choice box with items from options
        // Initially shows first item in options
        optionsFrom(optStrings)
    }
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


def audio is public = object {
    class url(source': String) -> Audio {
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

