#Week 4 - Class 2
##Homework
* Create / implement login screen. App should check to see if token exists before displaying / making a call to Github. If token does not exist, present login screen.
* Implement the ability fetch repositories using a GET request. NOTE: Please make sure you include "repo" in your initial scope when requesting a token.
* Create a model for Repository, User, and repository Owner.
* Create a HomeViewController and parse through the JSON returned from the server into models. No UI needed at this point, just print the information into the console.
* **Code Challenge:**
	* Write a function that takes in an array of numbers, and returns the lowest and highest numbers as a tuple.

##Reading Assignment:
* Apple Documentation:
	* [UIViewController Programming Guide](https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/index.html#//apple_ref/doc/uid/TP40007457-CH2-SW1)
	* [UIView Animations Guide](https://developer.apple.com/library/ios/documentation/WindowsViews/Conceptual/ViewPG_iPhoneOS/AnimatingViews/AnimatingViews.html#//apple_ref/doc/uid/TP40009503-CH6-SW1)
* Other Resources:
	* [Custom UIViewController Transitions](https://www.objc.io/issues/5-ios7/view-controller-transitions/)

##Other Resources
* [Reading Assignments](../../Resources/ra-grading-standard/)
* [Grading Rubrics](../../Resources/)
* [Lecture Resources](lecture/)
* [Lecture Slides](https://www.icloud.com/keynote/000QTHpeeBGGo_aR7U3F-rjiA#Week4_Day2)

UISEARCHBAR!
Class is a text field based control.

Search bar provides text field for text input, a saerch button, bookmark butotn, cancel button.
Relies on its delegate to perofmr searches when one of its buttons is pressed
Can be also embed into a tableview byd ragging it into the tableview on storyboard.

Recommended to apply regex to search bars.  If you are searching for email, you want to invalidate spaces (making regex nice)

Keychain services provides secure storage for passwords, keys, certificates, notes for one or more users.
Keychain is weird.
Keychian is a C based API.

QUERIES IN Keychain
anytime you access the Keychain, you need to pass in a keychian query.
a keychain query is jsut a dictionary that uses predefined keys

kSecReturnData - pass in kCFBooleanTrue: True when you're trying ot retrieve the item from Keychain.

kSecClassKey - key whose value is the items class code.  Class codes are generic password, internet password, cert, key, identify

kSecAttr* - this is where you specify info about the item you're looking for or storing.  If you specify your class as a generic or internet password, you want to yuse kSecAttrAccount

kSecValueData - you pass in the actual data as a string

Ternary Operator

concise if else.
allow if-else conditions in short hand syntax.


When to not uses
Used to set vars or constants

Used for making code more concise

Don't iuse if your conditions have more than one line

APP DELEGATE!

Regular object that conforims to UI application delegate protocol.
Defines methods that are called by singleton UIApplication object in response to important event in the lifetime of your app (going from foreground to background, receiving a local notification)

UIKit automatically creates an instance of the app delegate class provided by Xcode when you initially created your Project
The app delegate is effectively the root object of your app.

Contains your apps startup

DidFinishLaunchingWithOptions:
method is called after your app has finished its initailziation process but before the user sees any view controllers.

Great spot to change the root view controller of the app based on some preferences or data

Great place to check for required information, toke - for example.  If present, load main menu view controller.  If not, load login view controller.

UIWindow is class that manages and coordinates the view as an app displays on the device screen.
UIWIndow is a subclass UIView
Windows have 2 main jobs, provide area for displaying other views and distributing events to the views.


Windows have Z axis, whihch dictates which window overlays other windows.
Only window at a time is allowed to receive keyboard and related info, the keyWindow.

1. Always save to keychain
2. Login UI/Cleanup login VC/ scope: email, user, repo
3. Setup protocol/id setup appearance
4. HomeViewController: add scene to storyboard, becomes initial VC, set class, UITableView setup
5. AppDelegate: check for token, if no token, present login or token -> remove loginVC
6. API: singleton -> session, components (based on docs of Github) -> GET!
7. Populate tableView
