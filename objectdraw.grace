#pragma PrimitiveLists
#pragma noTypeChecks
inherits prelude.methods

import "js/dom" as dom
import "math" as math


// ** Helpers ***************************************************

// The frame rate of the drawing.
def frameRate : Number = 30

// A random number from m to n, inclusive.
method randomNumberFrom(m : Number) to(n : Number) -> Number {
  ((n - m) * math.random) + m
}

// A random integer from m to n, inclusive.
method randomIntFrom(m : Number) to(n : Number) -> Number {
  (((n - m + 1) * math.random).truncated % (n - m + 1)) + m
}

// A rough approximation of the value of pi.
def pi: Number is public = math.π

type Foreign = Unknown

def document : Foreign = dom.document

type Function<T, R> = prelude.Block1<T,R>
type Function2<T, U, R> = prelude.Block2<T, U, R>
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
  onMouseClickDo(f : MouseResponse) -> Done

  // Respond to a mouse press in this component with the given event.
  onMousePressDo(f : MouseResponse) -> Done

  // Respond to a mouse release in this component with the given event.
  onMouseReleaseDo(f : MouseResponse) -> Done

  // Respond to a mouse move in this component with the given event.
  onMouseMoveDo(f : MouseResponse) -> Done

  // Respond to a mouse drag (move during press) in this component with the
  // given event.
  onMouseDragDo(f : MouseResponse) -> Done

  // Respond to a mouse entering this component with the given event.
  onMouseEnterDo(f : MouseResponse) -> Done

  // Respond to a mouse exiting this component with the given event.
  onMouseExitDo(f : MouseResponse) -> Done

  // Respond to a key type (press and release) in this component with the given
  // event.
  onKeyTypeDo(f : KeyResponse) -> Done

  // Respond to a key press in this component with the given event.
  onKeyPressDo(f : KeyResponse) -> Done

  // Respond to a key release in this component with the given event.
  onKeyReleaseDo(f : KeyResponse) -> Done

  // Whether this component will dynamically fill up any empty space in the
  // direction of its parent container.
  isFlexible -> Boolean

  // Set whether this component will dynamically fill up any empty space in the
  // direction of its parent container.
  flexible := (value : Boolean) -> Done

}

// The type of components that contain other components.
type Container = Component & type {

  // The number of components inside this container.
  size -> Number

  // Retrieve the component at the given index.
  at(index : Number) -> Component

  // Put the given component at the given index.
  at(index : Number) put(component : Component) -> Done

  // Add a component to the end of the container.
  append(component : Component) -> Done

  // Add a component to the start of the container.
  prepend(component : Component) -> Done

  // Perform an action for every component inside this container.
  do(f : Procedure<Component>) -> Done

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
  windowTitle := (value : String) -> Done

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
  addToCanvas(canvas : DrawingCanvas) -> Done

  // Remove this object from its canvas.
  removeFromCanvas -> Done

  // Whether this object is currently set to be visible on the canvas.
  isVisible -> Boolean

  // Set whether this object is currently visible on the canvas.
  visible := (value : Boolean) -> Done

  // Move this object to the given point on the canvas.
  moveTo(location : Point) -> Done

  // Move this object by the given distances on the canvas.
  moveBy(dx : Number, dy : Number) -> Done

  // Whether the given location is inside this object.
  contains(location : Point) -> Boolean

  // Whether any point in the given graphic is inside this object.
  overlaps(graphic : Graphic2D) -> Boolean

  // set the color of this object to c
  color:=(c:Color)->Done

  // return the color of this object
  color->Color

  // Send this object up one layer on the screen
  sendForward->Done

  // send this object down one layer on the screen
  sendBackward -> Done

  // send this object to the top layer on the screen
  sendToFront -> Done

  // send this object to the bottom layer on the screen
  sendToBack -> Done
}


// DrawingCanvas holding graphic objects
type DrawingCanvas = Component & type {

  // Start drawing on the canvas. Will continue until the canvas is destroyed.
  startDrawing -> Done

  // add d to canvas
  add(d:Graphic)->Done

  // remove d from window
  remove(d:Graphic)->Done

  notifyRedraw -> Done

  // clear the canvas
  clear -> Done

  // Send d to top layer of graphics
  sendToFront(d:Graphic)->Done

  // send d to bottom layer of graphics
  sendToBack(d:Graphic)->Done

  // send d up one layer in graphics
  sendForward(d:Graphic)->Done

  // send d down one layer in graphics
  sendBackward(d:Graphic)->Done

  // return the current dimensions of the canvas
  width -> Number
  height -> Number

}

// Type of object that run a graphical application that draws
// objects on a screen and responds to mouse actions
type GraphicApplication = Application & type {
  // canvas holds graphic objects on screen
  canvas -> DrawingCanvas

  // Respond to a mouse click (press and release) in the canvas at the given
  // point.
  onMouseClick(mouse : Point) -> Done

  // Respond to a mouse press in the canvas at the given point.
  onMousePress(mouse : Point) -> Done

  // Respond to a mouse release in the canvas at the given point.
  onMouseRelease(mouse : Point) -> Done

  // Respond to a mouse move in the canvas at the given point.
  onMouseMove(mouse : Point) -> Done

  // Respond to a mouse drag (move during press) in the canvas at the given
  // point.
  onMouseDrag(mouse : Point) -> Done

  // Respond to a mouse entering the canvas at the given point.
  onMouseEnter(mouse : Point) -> Done

  // Respond to a mouse exiting the canvas at the given point.
  onMouseExit(mouse : Point) -> Done

  // must be invoked to create window and its contents as well as prepare the
  // window to handle mouse events
  startGraphics -> Done
}

// Two-dimensional objects that can also be resized
type Graphic2D = Graphic & type {
  // dimensions of object
  width->Number
  height->Number
  // Change dimensions of object
  setSize(width:Number,height:Number)->Done
  width:=(width:Number)->Done
  height:=(height:Number)->Done
}

// One-dimensional objects
type Line = Graphic & type {
  // start and end of line
  start -> Point
  end -> Point

  // set start and end of line
  start:=(start':Point) -> Done
  end:=(end':Point) -> Done
  setEndPoints(start':Point,end':Point) -> Done
}

// Text that can be drawn on a canvas.
type Text = Graphic & type {

   // return the contents displayed in the item
   contents -> String

   // reset the contents displayed to be s
   contents:=(s:String) -> Done

   // return width of text item (currently inaccurate)
   width -> Number

   // return size of the font used to display the contents
   fontSize -> Number

   // Set the size of the font used to display the contents
   fontSize:=(size:Number) -> Done

}

type TextBox = Component & type {

  // The text contents of the box.
  contents -> String
  contents := (value : String) -> Done

}

type Labeled = Component & type {

  // The label name.
  label -> String
  label := (value : String) -> Done

}

type Button = Labeled

type Input = Labeled & type {

  // Respond to this input gaining focus with the given event.
  onFocusDo(f : Response) -> Done

  // Respond to this input losing focus with the given event.
  onBlurDo(f : Response) -> Done

  // Respond to this input having its value changed.
  onChangeDo(f : Response) -> Done

}

type TextField = Input & type {

  // The contents of the text field.
  text -> String
  text := (value : String) -> Done

}

type NumberField = Input & type {

  // The contents of the number field.
  number -> Number
  number := (value : Number) -> Done

}


type Choice = Input & type {

  // The currently selected option.
  selected -> String
  selected := (value : String) -> Done

}

// ** Colors *******************************************************************

type Color = {

  // The red component of the color.
  red -> Number

  // The green component of the color.
  green -> Number

  // The blue component of the color.
  blue -> Number

}

def ColorOutOfRange : prelude.ExceptionKind is public =
  ProgrammingError.refine "Color Out Of Range"

// Simple color class
class color.r(r' : Number) g(g' : Number) b(b' : Number) -> Color {
  if((r' < 0) || (r' > 255)) then {
    ColorOutOfRange.raise "red index {r'} out of bounds 0..255"
  }

  if((g' < 0) || (g' > 255)) then {
    ColorOutOfRange.raise "green index {g'} out of bounds 0..255"
  }

  if((b' < 0) || (b' > 255)) then {
    ColorOutOfRange.raise "blue index {b'} out of bounds 0..255"
  }

  def red:Number is public = r'
  def green:Number is public = g'
  def blue:Number is public = b'

  method asString -> String {
    "rgb({red}, {green}, {blue})"
  }
}

// Produce a random color.
method randomColor -> Color {
  color.r(randomIntFrom(0) to(255))
    g(randomIntFrom(0) to(255))
    b(randomIntFrom(0) to(255))
}


// ** Events *******************************************************************

type Event = {
  source -> Component
}

type MouseEvent = Event & type {
  at -> Point
}

type KeyEvent = Event & type {
  //character -> String
  code -> Number
  //modifiers -> Modifiers
}

type Response = Procedure<Event>

type MouseResponse = Procedure<MouseEvent>

type KeyResponse = Procedure<KeyEvent>

class event.source(source' : Component) -> Event {
  def source : Component is public = source'

  method asString -> String{
    "Event on {source}"
  }
}

class mouseEvent.source(source' : Component)
    event(event' : Foreign) -> MouseEvent {
  inherits event.source(source')
  def at : Point is public = (event'.pageX - source.element.offsetLeft) @
    (event'.pageY - source.element.offsetTop)

  method asString -> String {
    "Mouse event on {source} at {at}"
  }
}

class keyEvent.source(source' : Component)
    event(event' : Foreign) -> KeyEvent {
  inherits event.source(source')
  def code : Number is public = event'.which
  //def character is public = dom.window.String.fromCharCode(event'.which)

  method asString -> String {
    "Key event on {source} for {code}"
  }
}


// ** Internal factories *******************************************************

// where T <: Component
type ComponentFactory<T> = {

  // Build a component around an existing element.
  fromElement(element) -> T

  // Build a component around a new element of the given tag name.
  ofElementType(tagName : String) -> T

}

// The maximum amount of time a mouse can be pressed before being released in
// order for the event to be registered as a click.
def maxClickTime : Number = 200

def component : ComponentFactory<Component> = object {
  factory method fromElement(element') -> Component {
    def element is public = element'

    method width -> Number {
      element.width
    }

    method height -> Number {
      element.height
    }

    method on(event' : String)
        do(f : Procedure<Foreign>) -> Done is confidential {
      element.addEventListener(event', f)
      done
    }

    method on(kind : String)
        withPointDo(f : MouseResponse) -> Done is confidential {
      on(kind) do { event' ->
        f.apply(mouseEvent.source(self) event(event'))
      }
    }

    method onMouseClickDo(f : MouseResponse) -> Done {
      var lastDown : Foreign

      on "mousedown" do { event' : Foreign ->
        lastDown := event'.timeStamp
      }

      on "click" do { event' : Foreign ->
        if ((event'.timeStamp - lastDown) <= maxClickTime) then {
          f.apply(mouseEvent.source(self) event(event'))
        }
      }
    }

    method onMousePressDo(f : MouseResponse) -> Done {
      on "mousedown" withPointDo(f)
    }

    method onMouseReleaseDo(f : MouseResponse) -> Done {
      on "mouseup" withPointDo(f)
    }

    method onMouseMoveDo(f : MouseResponse) -> Done {
      on "mousemove" do { event' ->
        if (if(dom.doesObject(event') haveProperty("buttons")) then {
          event'.buttons == 0
        } else {
          event'.which == 0
        }) then {
          f.apply(mouseEvent.source(self) event(event'))
        }
      }
    }

    method onMouseDragDo(f : MouseResponse) -> Done {
      on "mousemove" do { event' ->
        if (if(dom.doesObject(event') haveProperty("buttons")) then {
          event'.buttons == 1
        } else {
          event'.which == 1
        }) then {
          f.apply(mouseEvent.source(self) event(event'))
        }
      }
    }

    method onMouseEnterDo(f : MouseResponse) -> Done {
      on "mouseover" do { event' ->
        def from = event'.relatedTarget

        if ((from == done).orElse { !element.contains(from) }) then {
          f.apply(mouseEvent.source(self) event(event'))
        }
      }
    }

    method onMouseExitDo(f : MouseResponse) -> Done {
      on "mouseout" do { event' ->
        def to = event'.relatedTarget

        if ((to == done).orElse { !element.contains(to) }) then {
          f.apply(mouseEvent.source(self) event(event'))
        }
      }
    }

    method on(kind : String)
        withKeyDo(f : KeyResponse) -> Done is confidential {
      on(kind) do { event' ->
        f.apply(keyEvent.source(self) event(event'))
      }
    }

    method onKeyPressDo(f : KeyResponse) -> Done {
      on "keydown" withKeyDo(f)
    }

    method onKeyReleaseDo(f : KeyResponse) -> Done {
      on "keyup" withKeyDo(f)
    }

    method onKeyTypeDo(f : KeyResponse) -> Done {
      on "keypress" withKeyDo(f)
    }

    method isFlexible -> Boolean {
      element.style.flexGrow.asNumber > 0
    }

    method flexible := (value : Boolean) -> Done {
      element.style.flexGrow := if (value) then {
        1
      } else {
        0
      }
    }

    method asString -> String {
      "a component"
    }
  }

  factory method ofElementType(tagName : String) -> Component {
    inherits fromElement(document.createElement(tagName))
  }
}

def container : ComponentFactory<Container> is public = object {
  factory method ofElementType(tagName : String) -> Component {
    inherits fromElement(document.createElement(tagName))
  }

  factory method fromElement(element') -> Container {
    inherits component.fromElement(element')

    def children = []

    method size -> Number {
      children.size
    }

    method isEmpty -> Boolean {
      size == 0
    }

    method at(index : Number) -> Component {
      if ((index < 1) || (index > size)) then {
        collections.BoundsError.raiseForIndex(index)
      }

      children.at(index)
    }

    method at(index : Number) put(aComponent : Component) -> Done {
      if ((index < 1) || (index > (size + 1))) then {
        BoundsError.raiseForIndex(index)
      }

      if (index == (size + 1)) then {
        element.appendChild(aComponent.element)
      } else {
        element.insertBefore(aComponent.element, children.at(index).element)
      }

      children.at(index) put(aComponent)

      done
    }

    method append(aComponent : Component) -> Done {
      element.appendChild(aComponent.element)

      children.push(aComponent)

      done
    }

    method prepend(aComponent : Component) -> Done {
      if (isEmpty) then {
        element.appendChild(aComponent.element)
      } else {
        element.insertBefore(aComponent.element, element.firstChild)
      }

      children.unshift(aComponent)

      done
    }

    method do(f : Procedure<Component>) -> Done {
      for (children) do { aComponent ->
        f.apply(aComponent)
      }
    }

    method fold<T>(f : Function2<T, Component, T>)
        startingWith(initial : T) -> T {
      var value : T := initial

      for (children) do { aComponent ->
        value := f.apply(value, aComponent)
      }

      value
    }

    method flex -> Done is confidential {
      element.style.display := "inline-flex"
      element.style.justifyContent := "center"
      element.style.flexFlow := "row wrap"
    }

    method arrangeHorizontal -> Done {
      flex
      element.style.flexDirection := "row"
    }

    method arrangeVertical -> Done {
      flex
      element.style.flexDirection := "column"
    }

    method asString -> String {
      "container: with {size} children"
    }
  }

  factory method empty -> Container {
    inherits ofElementType("div")

    self.arrangeHorizontal
  }

  factory method size(width' : Number, height' : Number) -> Container {
    inherits empty

    self.element.style.width := "{width'}px"
    self.element.style.height := "{height'}px"
    self.element.style.overflow := "auto"
  }
}

def input : ComponentFactory<Input> = object {
  factory method fromElement(element') -> Input {
    inherits component.fromElement(element')

    method onFocusDo(f : Response) -> Done {
      element.addEventListener("focus", { _ ->
        f.apply(event.source(self))
      })
    }

    method onBlurDo(f : Response) -> Done {
      element.addEventListener("blur", { _ ->
        f.apply(event.source(self))
      })
    }

    method onChangeDo(f : Response) -> Done {
      element.addEventListener("change", { _ ->
        f.apply(event.source(self))
      })
    }

    method asString -> String {
      "an input"
    }
  }

  factory method ofElementType(elementType : String) -> Input {
    inherits fromElement(document.createElement(elementType))
  }

  factory method ofType(inputType : String) -> Input {
    inherits ofElementType("input")

    self.element.setAttribute("type", inputType)
  }
}

def labeledWidget : ComponentFactory<Labeled> = object {
  factory method fromElement(element') -> Labeled {
    inherits input.fromElement(element')

    method labelElement -> Foreign is confidential {
      self.element
    }

    method label -> String {
      labelElement.textContent
    }

    method label := (value : String) -> Done {
      labelElement.textContent := value
      done
    }

    method asString -> String {
      "an input labeled: {label}"
    }
  }

  factory method ofElementType(elementType : String) -> Labeled {
    inherits fromElement(document.createElement(elementType))
  }

  factory method ofElementType(elementType : String)
      labeled(label' : String) -> Labeled {
    inherits ofElementType(elementType)

    self.label := label'
  }
}

class field.ofType(inputType : String) labeled(label' : String) -> Input {
  inherits input.ofType(inputType)

  method label -> String {
    self.element.placeholder
  }

  method label := (value : String) -> Done {
    self.element.placeholder := value
    done
  }

  method asString -> String {
    "a field labeled: {label}"
  }

  label := label'
}


// ** External factories *******************************************************

class eventLog.kind(kind' : String)
    response(response' : Procedure) is confidential {
  def kind : String is public = kind'
  def response : Procedure is public = response'
}

class application.title(initialTitle : String)
    size(initialWidth : Number, initialHeight : Number) -> Application {
  inherits container.fromElement(document.createDocumentFragment)

  var isOpened : Boolean := false
  var theWindow : Foreign

  var theTitle : String := initialTitle
  var theWidth : Number := initialWidth
  var theHeight : Number := initialHeight

  def events = []

  method element -> Foreign {
    if (isOpened) then {
      theWindow.document.body
    } else {
      super.element
    }
  }

  var isHorizontal : Boolean := true

  method arrangeHorizontal -> Done {
    if (isOpened) then {
      super.arrangeHorizontal
    } else {
      isHorizontal := true
    }
  }

  method arrangeVertical -> Done {
    if (isOpened) then {
      super.arrangeVertical
    } else {
      isHorizontal := false
    }
  }

  method on(kind : String)
      do(response : Procedure<Event>) -> Done is confidential {
    if (isOpened) then {
      theWindow.addEventListener(kind, response)
    } else {
      events.push(eventLog.kind(kind) response(response))
    }
  }

  method windowTitle -> String {
    if (isOpened) then {
      theWindow.title
    } else {
      theTitle
    }
  }

  method windowTitle := (value : String) -> Done {
    if (isOpened) then {
      theWindow.title := value
    } else {
      theTitle := value
    }
  }

  method width -> Number {
    if (isOpened) then {
      theWindow.width
    } else {
      theWidth
    }
  }

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

  method onMouseEnterDo(f : MouseResponse) -> Done {
    on "mouseover" do { event' ->
      def from = event'.relatedTarget

      if (from == done) then {
        f.apply(mouseEvent.source(self) event(event'))
      }
    }
  }

  method onMouseExitDo(f : MouseResponse) -> Done {
    on "mouseout" do { event' ->
      def to = event'.relatedTarget

      if (to == done) then {
        f.apply(mouseEvent.source(self) event(event'))
      }
    }
  }

  method onMouse(kind : String) do(bl : MouseResponse) -> Done is confidential {
    theWindow.addEventListener(kind, { evt ->
      bl.apply(evt.pageX @ evt.pageY)
    })
  }

  method startApplication -> Done {
    if (!isOpened) then {
      theWindow := dom.window.open("", "", "width={theWidth},height={theHeight}")
      theWindow.document.title := theTitle
      theWindow.document.body.appendChild(element)

      if (dom.doesObject(dom.window) haveProperty("graceRegisterWindow")) then {
        dom.window.graceRegisterWindow(theWindow)
      }

      isOpened := true

      element.style.width := "100%"
      element.style.margin := "0px"

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

  method stopApplication  -> Done {
    if (isOpened) then {
      theWindow.close
    }
  }

  method asString -> String {
    "application titled {windowTitle}"
  }
}

// class representing objects that manage graphics on screen
class drawingCanvas.size(width' : Number, height' : Number) -> DrawingCanvas {
  inherits component.fromElement(document.createElement("canvas"))

  element.width := width'
  element.height := height'
  element.style.alignSelf := "center"

  def theContext : Foreign = element.getContext("2d")
  theContext.lineWidth := 2

  method width -> Number {
    element.width
  }

  method height -> Number {
    element.height
  }

  // list of all objects on canvas (hidden or not)
  var theGraphics := []

  var redraw : Boolean := false

  method notifyRedraw -> Done {
    redraw := true
  }

  method startDrawing -> Done {
    element.ownerDocument.defaultView.setInterval({
      if (redraw) then {
        dom.draw(theContext, theGraphics, width, height)
      }
    }, 1000 / frameRate)
  }

  // remove all items from canvas
  method clear -> Done {
    theGraphics := []
    notifyRedraw
  }

  // Add new item d to canvas
  method add(d:Graphic) -> Done {
    theGraphics.push(d)
    notifyRedraw
  }

  // remove m from items on canvas
  method remove(aGraphic : Graphic) -> Done {
    theGraphics.remove(aGraphic)
    notifyRedraw
  }

  // send item d to front/top layer of canvas
  method sendToFront(aGraphic : Graphic) -> Done {
    theGraphics.remove(aGraphic)
    theGraphics.push(aGraphic)
    notifyRedraw
  }

  // send item d to back/bottom layer of canvas
  method sendToBack(aGraphic : Graphic) -> Done {
    theGraphics.remove(aGraphic)
    theGraphics.unshift(aGraphic)
    notifyRedraw
  }

  // send item d one position higher on canvas
  method sendForward(aGraphic : Graphic) -> Done {
    def theIndex = theGraphics.indexOf(aGraphic)

    if (theIndex == theGraphics.size) then {
      return
    }

    theGraphics.remove(aGraphic)
    theGraphics.at(theIndex + 1) add(aGraphic)
    notifyRedraw
  }

  // send item d one position lower on canvas
  method sendBackward(aGraphic : Graphic)->Done {
    def theIndex = theGraphics.indexOf(aGraphic)

    if (theIndex == 1) then {
      return
    }

    theGraphics.remove(aGraphic)
    theGraphics.at(theIndex - 1) add(aGraphic)
    notifyRedraw
  }

  // debug method to print all objects on canvas
  method printObjects -> Done {
    for(theGraphics) do { aGraphic ->
      print(aGraphic)
    }
  }

  // string representation of canvas
  method asString -> String {
   "canvas: with {theGraphics.size} objects"
  }
}

// abstract class to be extended to create graphic application using mouse actions
class graphicApplication
    .size(theWidth' : Number, theHeight' : Number) -> GraphicApplication {
  inherits application.title("Simple graphics") size(theWidth', theHeight')

  def canvas : DrawingCanvas is public = drawingCanvas.size(theWidth, theHeight)

  children.push(canvas)

  def before : Container = container.empty
  def after : Container = container.empty

  arrangeVertical
  element.appendChild(before.element)
  element.appendChild(canvas.element)
  element.appendChild(after.element)

  method prepend(aComponent : Component) -> Done {
    before.prepend(aComponent)
    children.unshift(aComponent)
  }

  method append(aComponent : Component) -> Done {
    after.append(aComponent)
    children.push(aComponent)
  }

  method onMouseClick(mouse : Point) -> Done {}

  method onMousePress(mouse : Point) -> Done {}

  method onMouseRelease(mouse : Point) -> Done {}

  method onMouseMove(mouse : Point) -> Done {}

  method onMouseDrag(mouse : Point) -> Done {}

  method onMouseEnter(mouse : Point) -> Done {}

  method onMouseExit(mouse : Point) -> Done {}

  method startGraphics -> Done {
    def parentElement = document.createElement("div")
    parentElement.className := "height-calculator"
    parentElement.style.width := "{theWidth}px"
    parentElement.appendChild(element.cloneNode(true))
    document.body.appendChild(parentElement)
    theHeight := parentElement.offsetHeight
    document.body.removeChild(parentElement)

    startApplication
    canvas.startDrawing

    theWindow.document.documentElement.style.overflow := "hidden"

    canvas.onMouseClickDo { event' ->
      onMouseClick(event'.at)
    }

    canvas.onMousePressDo { event' ->
      onMousePress(event'.at)
    }

    canvas.onMouseReleaseDo { event' ->
      onMouseRelease(event'.at)
    }

    canvas.onMouseMoveDo { event' ->
      onMouseMove(event'.at)
    }

    canvas.onMouseDragDo { event' ->
      onMouseDrag(event'.at)
    }

    canvas.onMouseEnterDo { event' ->
      onMouseEnter(event'.at)
    }

    canvas.onMouseExitDo { event' ->
      onMouseExit(event'.at)
    }
  }

  method asString -> String {
    "graphic application of {canvas}"
  }
}

// predefined colors in objectdraw
def white:Color is public = color.r(255)g(255)b(255)
def black:Color is public = color.r(0)g(0)b(0)
def green:Color is public = color.r(0)g(255)b(0)
def red:Color is public = color.r(255)g(0)b(0)
def gray:Color is public = color.r(60)g(60)b(60)
def blue:Color is public = color.r(0)g(0)b(255)
def cyan:Color is public = color.r(0)g(255)b(255)
def magenta:Color is public = color.r(255)g(0)b(255)
def yellow:Color is public = color.r(255)g(255)b(0)
def neutral:Color is public = color.r(220)g(220)b(220)


// abstract superclass for drawable objects
class drawable.at(location':Point) on (canvas':DrawingCanvas) -> Graphic {

  // location of object on screen
  var location : Point is readable := location'

  // x coordinate of object
  method x -> Number {
    location.x
  }

  // y coordinate of object
  method y -> Number {
     location.y
  }

  // The canvas this object is part of
  var canvas : DrawingCanvas := canvas'

  // the color of this object
  var theColor : Color := black

  method color -> Color {theColor}

  method color:=(newColor:Color) -> Done {
    theColor := newColor
    notifyRedraw
  }

  var theFrameColor:Color := black
  method frameColor -> Color { theFrameColor }
  method frameColor:=(newfColor:Color) -> Done {
    theFrameColor := newfColor
    notifyRedraw
  }

  // Determine if object is shown on screen
  var isVisible:Boolean is readable := true

  method visible:=(b:Boolean) -> Done {
    isVisible := b
    notifyRedraw
  }

  // Add this object to canvas c
  method addToCanvas(c:DrawingCanvas)->Done {
    removeFromCanvas
    canvas := c
    c.add(self)
    notifyRedraw
  }

  // Remove this object from its canvas
  method removeFromCanvas->Done {
    canvas.remove(self)
    notifyRedraw
  }

  // move this object to newLocn
  method moveTo(newLocn:Point)->Done{
    location := newLocn
    notifyRedraw
  }

  // move this object dx to the right and dy down
  method moveBy(dx:Number,dy:Number)->Done{
    location := location+(dx@dy)
    notifyRedraw
  }

  method contains(locn:Point) -> Boolean {
    SubobjectResponsibility.raise "contains not implemented for {self}"
  }

  method overlaps(otheObject:Graphic2D) -> Boolean {
    SubobjectResponsibility.raise "overlaps not implemented for {self}"
  }

  // Send this object up one layer on the screen
  method sendForward->Done{
    canvas.sendForward(self)
  }

  // send this object down one layer on the screen
  method sendBackward->Done{
    canvas.sendBackward(self)
  }

  // send this object to the top layer on the screen
  method sendToFront->Done{
    canvas.sendToFront(self)
  }

  // send this object to the bottom layer on the screen
  method sendToBack->Done{
    canvas.sendToBack(self)
  }

  // Tell the system that the screen needs to be repainted
  method notifyRedraw -> Done is confidential {
    canvas.notifyRedraw
  }

  // Draw this object on the applet !! confidential
  method draw(ctx : Foreign) -> Done {
    SubobjectResponsibility.raise "draw not implemented for {self}"
  }

  // Return a string representation of the object
  method asString -> String {
    "Graphic object"
  }
}


// abstract class for two-dimensional objects
class drawable2D.at(location':Point)size(width':Number,height':Number)on(canvas':DrawingCanvas)
                      -> Graphic2D{
  inherits drawable.at(location')on(canvas')
  var theWidth:Number := width'
  method width -> Number {theWidth}
  var theHeight:Number := height'
  method height -> Number {theHeight}

  method contains(locn:Point)->Boolean{
    (x <= locn.x) && (locn.x <= (x + width))
         &&(y <= locn.y) && (locn.y <= (y + height))
  }

  method overlaps(other:Graphic2D)->Boolean{
    def itemleft = other.x
    def itemright = other.x + other.width
    def itemtop = other.y
    def itembottom = other.y+other.height
    def disjoint:Boolean = ((x+width) < itemleft) || (itemright < x)
                        || ((y+height) < itemtop) || (itembottom < y)
    return !disjoint
  }

  method asString -> String {
    "drawable2D object at ({x},{y}) "++
         "with height {height}, width {width}, and color {color}"
  }
}

// abstract class to be extended for 2 dimensional objects that can be
// resized.
class resizable2D.at(location':Point)size(width':Number,height':Number)
                   on(canvas':DrawingCanvas)  -> Graphic2D{
  inherits drawable2D.at(location')size(width',height')on(canvas')

  method width:=(w:Number) -> Done {
    theWidth := w
    notifyRedraw
  }

  method height:=(h:Number) -> Done {
    theHeight := h
    notifyRedraw
  }

  method setSize(w:Number,h:Number) -> Done{
    width := w
    height := h
  }

  method asString -> String {
    "Resizable2D object at ({x},{y}) "++
         "with height {height}, width {width}, and color {color}"
  }

}

// class to generate framed rectangle at (x',y') with size width' x height'
// created on canvas'
class framedRect.at(location':Point)size(width':Number,height':Number)
           on(canvas':DrawingCanvas) -> Graphic2D{
  inherits resizable2D.at(location')size(width',height')on(canvas')
  addToCanvas(canvas')

  method draw(ctx : Foreign) -> Done {
    ctx.save
    ctx.strokeStyle := "rgb({color.red}, {color.green}, {color.blue})"
    ctx.strokeRect(x, y, width, height)
    ctx.restore
  }

  method asString -> String {
    "FramedRect at ({x},{y}) "++
         "with height {height}, width {width}, and color {color}"
  }

}

// class to generate filled rectangle at (x',y') with size width' x height'
// created on canvas'
class filledRect.at(location':Point)size(width':Number,height':Number)
           on(canvas':DrawingCanvas) -> Graphic2D {
  inherits resizable2D.at(location')size(width',height')on(canvas')

  addToCanvas(canvas')

  method draw(ctx : Foreign) -> Done {
    ctx.save
    ctx.fillStyle := "rgb({color.red}, {color.green}, {color.blue})"
    ctx.fillRect(x, y, width, height)
    ctx.restore
  }

  method asString -> String {
    "FilledRect at ({x},{y}) "++
         "with height {height}, width {width}, and color {color}"
  }

}


// class to generate framed oval at (x',y') with size width' x height'
// created on canvas'
class framedOval.at(location':Point)size(width':Number,height':Number)
           on(canvas':DrawingCanvas) -> Graphic2D{
  inherits resizable2D.at(location')size(width',height')on(canvas')
  addToCanvas(canvas')

  method draw(ctx : Foreign)->Done {
    ctx.beginPath
    ctx.save
    ctx.translate(x+width/2,y+height/2)
    ctx.scale(width/2,height/2)
    ctx.arc(0,0,1,0,2*pi)
    ctx.restore
    ctx.save
    ctx.strokeStyle := "rgb({color.red}, {color.green}, {color.blue})"
    ctx.stroke
    ctx.restore
    ctx.closePath
  }

  method asString -> String {
    "FramedOval at ({x},{y}) "++
         "with height {height}, width {width}, and color {color}"
  }

}

// class to generate filled oval at (x',y') with size width' x height'
// created on canvas'
class filledOval.at(location':Point)size(width':Number,height':Number)
           on(canvas':DrawingCanvas) -> Graphic2D{
  inherits resizable2D.at(location')size(width',height')on(canvas')

  addToCanvas(canvas')

  method draw(ctx : Foreign)->Done {
    ctx.beginPath
    ctx.save
    ctx.translate(x+width/2,y+height/2)
    ctx.scale(width/2,height/2)
    ctx.arc(0,0,1,0,2*pi)
    ctx.restore
    ctx.save
    ctx.fillStyle := "rgb({color.red}, {color.green}, {color.blue})"
    ctx.fill
    ctx.restore
    ctx.closePath
  }

  method asString -> String {
    "FilledOval at ({x},{y}) "++
         "with height {height}, width {width}, and color {color}"
  }

}

// class to generate framed arc at (x',y') with size width' x height'
// from startAngle radians to endAngle radians created on canvas'
// Note that angle 0 is in direction of positive x axis and increases in
// angles go clockwise.
class framedArc.at(location':Point)size(width':Number,height':Number)
           from(startAngle:Number)to(endAngle:Number)on(canvas':DrawingCanvas) -> Graphic2D{
  inherits resizable2D.at(location')size(width',height')on(canvas')
  addToCanvas(canvas')

  method draw(ctx : Foreign)->Done {
    ctx.beginPath
    ctx.save
    ctx.translate(x+width/2,y+height/2)
    ctx.scale(width/2,height/2)
    if (startAngle <= endAngle) then {
       ctx.arc(0,0,1,(startAngle*pi)/180,(endAngle*pi)/180)
    } else {
       ctx.arc(0,0,1,(endAngle*pi)/180,(startAngle*pi)/180)
    }
    ctx.restore
    ctx.save
    ctx.strokeStyle := "rgb({color.red}, {color.green}, {color.blue})"
    ctx.stroke
    ctx.restore
    ctx.closePath
  }

  method asString -> String {
    "FramedArc at ({x},{y}) "++
         "with height {height}, width {width}, and color {color} going "++
         "from {startAngle} degrees to {endAngle} degrees"
  }

}


// class to generate filled arc at (x',y') with size width' x height'
// from startAngle degrees to endAngle degrees created on canvas'
// Note that angle 0 is in direction of positive x axis and increases in
// angles go clockwise.
class filledArc.at(location':Point)size(width':Number,height':Number)
           from(startAngle:Number)to(endAngle:Number)on(canvas':DrawingCanvas) -> Graphic2D{
  inherits resizable2D.at(location')size(width',height')on(canvas')
  addToCanvas(canvas')

  method draw(ctx : Foreign)->Done {
    ctx.beginPath
    ctx.save
    ctx.translate(x+width/2,y+height/2)
    ctx.scale(width/2,height/2)
    if (startAngle <= endAngle) then {
      ctx.arc(0,0,1,(startAngle*pi)/180,(endAngle*pi)/180)
    } else {
      ctx.arc(0,0,1,(endAngle*pi)/180,(startAngle*pi)/180)
    }
    ctx.restore
    ctx.save
    ctx.fillStyle := "rgb({color.red}, {color.green}, {color.blue})"
    ctx.fill
    ctx.save
    ctx.closePath
  }

  method asString -> String {
    "FilledArc at ({x},{y}) "++
         "with height {height}, width {width}, and color {color} going "++
         "from {startAngle} degrees to {endAngle} degrees"
  }

}

type DrawableImageFactory = {
  //at(location : Point) size(width : Number, height : Number)
    //file(fileName : String) on (canvas : DrawingCanvas) -> Graphic2D

  at(location : Point) size(width : Number, height : Number)
    url(url : String) on (canvas : DrawingCanvas) -> Graphic2D
}

// class to generate an image on canvas' at (x',y') with size width' x height'
// The image is taken from the file fileName and must be in "png" format.
// currently doesn't work, perhaps because can't find file.
def drawableImage : DrawableImageFactory = object {
//  factory method at(location' : Point)
//      size(width' : Number, height' : Number)
//      file(fileName : String)
//      on(canvas' : DrawingCanvas) -> Graphic2D {
//    inherits resizable2D.at(location')size(width',height')on(canvas')
//
//    if (!dom.window.graceHasFile(fileName)) then {
//      NoSuchFile.raise "The file '{fileName}' could not be found"
//    }
//
//    def theImage = dom.document.createElement("img")
//    theImage.src := dom.window.graceReadFile(fileName)
//
//    method draw(ctx : Foreign) -> Done {
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

  factory method at(location' : Point)
      size(width' : Number, height' : Number)
      url(url : String)
      on(canvas' : DrawingCanvas) -> Graphic2D {
    inherits resizable2D.at(location')size(width',height')on(canvas')

    var theImage := document.createElement("img")
    theImage.src := url

    theImage.addEventListener("load", { _ ->
      addToCanvas(canvas')
    })

    method draw(ctx : Foreign) -> Done {
      ctx.drawImage(theImage, x, y, width, height)
    }

    method asString -> String {
      "DrawableImage at ({x},{y}) "++
           "with height {height}, width {width}, "++
           "from url {url}"
    }
  }
}

type LineFactory = {
  from(start':Point) to(end':Point) on(canvas':DrawingCanvas) -> Line

  from (pt: Point)
    length(len: Number)
    direction(radians: Number)
    on(canvas':DrawingCanvas) -> Line
}

def line = object {
  // Create a line from start' to end' on canvas'
  factory method from(start':Point)to(end':Point)on(canvas':DrawingCanvas) -> Line {
    inherits drawable.at(start')on(canvas')

    var theEnd: Point := end'

    // position of start of line (same as location)
    method start -> Point {
      location
    }

    // position of end of line
    method end -> Point {theEnd}

    addToCanvas(canvas')

    // set start and end of line
    method start:=(newStart:Point) -> Done {
      location := newStart
      notifyRedraw
    }

    method end:=(newEnd:Point) -> Done {
      theEnd := newEnd
      notifyRedraw
    }

    method setEndPoints(newStart:Point,newEnd:Point) -> Done {
      start := newStart
      end := newEnd
    }

    method draw(ctx : Foreign)->Done {
      ctx.save
      ctx.strokeStyle := "rgb({color.red}, {color.green}, {color.blue})"
      ctx.beginPath
      ctx.moveTo(location.x, location.y)
      ctx.lineTo(theEnd.x, theEnd.y)
      ctx.stroke
      ctx.restore
    }

    method moveBy(dx:Number,dy:Number) -> Done {
      location := location + (dx@dy)  //.translate(dx,dy)
      theEnd := theEnd + (dx@dy) //.translate(dx,dy)
      notifyRedraw
    }

    method dist2(v:Point, w:Point) -> Number is confidential {
      ((v.x - w.x) ^ 2) + ((v.y - w.y) ^ 2)
    }

    method distToSegmentSquared(p:Point, v:Point, w:Point) -> Number
         is confidential {
      var l2:Number := dist2(v, w)
      if (l2 == 0) then { return dist2(p, v)}
      var t:Number := ((p.x - v.x) * (w.x - v.x) + (p.y - v.y) * (w.y - v.y)) / l2
      if (t < 0) then {return dist2(p, v)}
      if (t > 1) then {return dist2(p, w)}
      dist2(p, ( (v.x + t * (w.x - v.x))@
                       (v.y + t * (w.y - v.y) )))
    }

    method distToSegment(p:Point, v:Point, w:Point) -> Number {
      math.sqrt(distToSegmentSquared(p, v, w))
    }

    method contains(pt:Point) -> Boolean {
      def tolerance: Number = 2  // say true if pt within tolerance of line
      distToSegment(pt,start,end) < tolerance
    }

    method asString -> String {
      "Line from {start} to {end} with color {color}"
    }
  }

  method from(pt: Point)
      length(len: Number)
      direction(radians: Number)
      on(canvas':DrawingCanvas) -> Line {
    def endpt = pt + ((len*math.cos(radians))@(-len*math.sin(radians)))
    line.from(pt) to (endpt) on (canvas')
  }
}

// class to generate text at location' on canvas' initially showing 
// contents'
class text.at(location':Point)
    with(contents':String)
    on(canvas':DrawingCanvas) -> Text {
  inherits drawable.at(location')on(canvas')

  var theContents:String := contents'
  var fsize:Number is readable := 10

  method width -> Number {
    theContents.size*fsize/2
  }

  method draw(ctx : Foreign) -> Done {
    ctx.save
    ctx.font := "{fontSize}pt sans-serif"
    ctx.fillStyle := "rgb({color.red}, {color.green}, {color.blue})"
    ctx.fillText(contents, location.x, location.y)
    ctx.restore
  }

  method contents -> String {
    theContents
  }

  method contents:=(newContents:String) -> Done {
    theContents := newContents
    notifyRedraw
  }

  method fontSize:=(size':Number) -> Done {
    fsize := size'
    notifyRedraw
  }

  method fontSize -> Number {
    fsize
  }

  method asString -> String {
    "Text at ({x},{y}) with value {contents} and color {color}"
  }

  addToCanvas(canvas')
}

class textBox.with(contents' : String) -> TextBox {
  inherits component.ofElementType("span")

  method contents -> String {
    self.element.textContent
  }

  method contents := (value : String) -> Done {
    self.element.textContent := value
    done
  }

  method asString -> String {
    "a text box"
  }

  contents := contents'
}

class button.labeled(label' : String) -> Button {
  inherits labeledWidget.ofElementType("button") labeled(label')

  method asString -> String {
    "a button labeled: {self.label}"
  }
}

type FieldFactory = {
  labeled(label : String) -> Input

  unlabeled -> Input
}

def textField : FieldFactory is public = object {
  factory method labeled(label' : String) -> TextField {
    inherits field.ofType("text") labeled(label')

    method text -> String {
      self.element.value
    }

    method text := (value : String) -> Done {
      self.element.value := value
    }

    method asString -> String {
      if (self.label == "") then {
        "a text field"
      } else {
        "a text field labeled: {self.label}"
      }
    }
  }

  factory method unlabeled -> TextField {
    inherits labeled ""
  }

  method asString -> String {
    "textField"
  }
}

def passwordField : FieldFactory is public = object {
  factory method labeled(lab : String) -> Input {
    inherits textField.labeled(lab)

    self.element.setAttribute("type", "password")

    method asString -> String {
      if (self.label == "") then {
        "a password field"
      } else {
        "a password field labeled: {self.label}"
      }
    }
  }

  factory method unlabeled -> TextField {
    inherits labeled ""
  }

  method asString -> String {
    "passwordField"
  }
}

def numberField : FieldFactory is public = object {
  factory method labeled(label' : String) -> NumberField {
    inherits field.ofType("number") labeled(label')

    method number -> Number {
      self.element.value.asNumber
    }

    method number := (value : Number) -> Done {
      self.element.value := value
    }

    method asString -> String {
      if (self.label == "") then {
        "a number field"
      } else {
        "a number field labeled: {self.label}"
      }
    }
  }

  factory method unlabeled -> NumberField {
    inherits labeled ""
  }

  method asString -> String {
    "numberField"
  }
}

type ChoiceFactory = {
  options(*options : String) labeled(label : String) -> Choice
  options(*options : String) -> Choice
}

def selectBox : ChoiceFactory is public = object {
  method optionsFrom(options : Sequence<String>) labeled(label' : String) -> Choice {
    def labeler : Foreign = document.createElement("option")
    labeler.value := ""

    object {
      inherits labeledWidget.ofElementType("select") labeled(label')

      method labelElement -> Foreign {
        labeler
      }

      self.element.appendChild(labeler)

      for (options) do { name : String ->
        def anOption : Foreign = document.createElement("option")
        anOption.value := name
        anOption.textContent := name
        self.element.appendChild(anOption)
      }

      method selected -> String {
        self.element.value
      }

      method selected := (value : String) -> Done {
        self.element.value := value
      }

      method asString -> String {
        if (self.label == "") then {
          "a select box"
        } else {
          "a select box labeled: {self.label}"
        }
      }
    }
  }

  factory method options(*options : String) labeled(label' : String) -> Choice {
    inherits optionsFrom(options) labeled(label')
  }

  factory method optionsFrom(options : Sequence<String>) -> Choice {
    inherits optionsFrom(options) labeled ""

    self.element.removeChild(self.labelElement)
  }

  factory method options(*optStrings : String) -> Choice {
    inherits optionsFrom(optStrings)
  }
}

type Audio = {

  // The source URL of the audio.
  source -> String
  source := (value : String) -> Done

  // Play the audio.
  play -> Done

  // Pause the audio.
  pause -> Done

  // Whether the audio will loop back to the start when it ends.
  isLooping -> Boolean
  looping := (value : Boolean) -> Done

  // Whether the audio has finished playing.
  isEnded -> Boolean

}

class audio.url(source' : String) -> Audio {
  def element = document.createElement("audio")

  element.src := source'

  if (dom.doesObject(dom.window) haveProperty("graceRegisterAudio")) then {
    dom.window.graceRegisterAudio(element)
  }

  method source -> String {
    element.src
  }

  method source := (value : String) -> Done {
    element.src := value
  }

  method play -> Done {
    element.play
  }

  method pause -> Done {
    element.pause
  }

  method isLooping -> Boolean {
    element.loop
  }

  method looping := (value : Boolean) -> Done {
    element.loop := value
  }

  method isEnded -> Boolean {
    element.ended
  }

  method asString -> String {
    "audio from {source}"
  }
}

