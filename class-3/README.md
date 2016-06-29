#Week 4 - Class 3
##Homework
* Create a table view in HomeViewController and populate it with repositories.
* Create ProfileViewController that will display User information. Build the UI similar to how it looks on Github. Use UITabBarController.
* Implement a UISearchBar on your repo search view controller and implement repo search. Use UITabBarController. Be sure to only be making authenticated network calls using your oath token!
* Implement a '+' to be able to create new repository using a POST request.
* **Code Challenge:**
	* Given a non-negative number "num", return true if num is within 2 of a multiple of 10. Note: (a % b) is the remainder of dividing a by b, so (7 % 5) is 2.

##Reading Assignment:
* Apple Documentation:
  * WKWebView
  * SafariViewController
* General Concepts:
  * Regex(Regular Expression)
  * Input Validation

##Other Resources
* [Reading Assignments](../../Resources/ra-grading-standard/)
* [Grading Rubrics](../../Resources/)
* [Lecture Resources](lecture/)
* [Lecture Slides](https://www.icloud.com/keynote/000lReqBJ1v41Z9NFhFkN3I8g#Week4_Day3)

ANIMATIONS!

TRANSITION! - smoothly animating from one visual state to the other.
FOCUS! - direct users attention to specific aspects of interface
DELIGHT! - making things look awesome.

PROCESS!
What are the initial properties of the item?
What are the final properties of the item?
HOw long should the animation take?
What's happening to this item while it is animating?
What will happen once this item is done animating?

LINEAR
EASE IN (curve downward)
EASE IN, EASE OUT (leans downward, then reveres)
Ease Out (upward curve)

Core animation

Core Animation is charge of all rendering on screen.
Core animation uses CALayer objects as its main unit of work.  UIView objects are wrappers around CALayers.

Layers can be arranged in a hierarchy just like UIView's.  you can build entire interface with CALayers.

CORE ANIMATION STACK:
UIKit (iOS) & AppKit (OS X)
Core ANIMATION
Open GL ES and OpenGL | Core Graphics
Graphics Hardware

Animation Techniques

Adding CAAnimation and its subclasses to al ayer.

Simple block/closure based system using class methods on UIView.

Key-frame animations, which is just a wrapper built around the lower level CAAnimation method.  Uses block / clsoure syntax.

Closure Based Animationcouple different class methods for the block based animation.
Two of them provide a paratmeter for a delay before the animatimo fires
One provides an options paramteres when you specivyt the curve type (ease in, ease out)
eone provides everything above, plus spring dampening.

SPRING ANIMATION!
The type of a motion being used to generage a spring (harmonci oscillation)

The key proeprites of a spring based of a spring's motion.

Key frame animations allow you to make animations that start and stop at different times, all relative to one duration interval.

Requires creation of a parent block that all the key frame animations iwll be created in.

Each key frame animation must be setup with a relative start and stop time inside the parent block.

The parent block supports a set of options for specific animation scenarios.

TRANSFORM!

Can be applied to views and layers to translate (move), scale, rotate, make a number of other changes to themselves.

Every view has a .transform peroperty which has a type of CGAFfineTransform.  STRUCT.

Transforms are represented by matrices

You can think of them as two dimensional array of numbers.

every view (and layer) starts out with their transofrm set to the identity matrix.

If a view's transform is set to the identity matrix, then we know no transforms have been applied to it.

For a view that has a transofmr that is set o the identity matrix, the view will be drawn based only on its frame and bounds.

Setting a view's transofmr back to the identity matrix will undo any transforms applied to it.

Transofrmers

Translation - fancy word for moving
;Rotation - rotates the view
Scaling - changes the size of the view.

CUSTOM VIEW CONTROLLER TRANSITION!

Custom Transitions!

Animation Controllers can be any class that conforms to UIViewControllerANimatedTransitioning protocol.  has 2 required methods to implement.

Animate Transition method
A place where you actually implemetn animations.

Gives transitionContext to work with, which gives you access to both the presenting view controller and teh presented view controller.  One or both are required to successfully perform transition.

The transitionContext provides you with the containerView.  The containerView essentially acts as the super view for both the preseting view controller's view and the presented view controllers views.

UIKit automatically adds the view of the presenting view controller.  You add the view of the toVC to the containerView and then animate it moving onsc reen.

Once teh animation is complete, call completeTransition() on the transitionContext
