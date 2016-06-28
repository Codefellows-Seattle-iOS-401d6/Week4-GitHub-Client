#Week 4 - Class 2
##Homework
* Implement saving token to Keychain. Your API should support both UserDefaults and Keychain.
* Create / implement login screen. App should check to see if token exists before displaying / making a call to Github. If token does not exist, present login screen.
* Implement the ability fetch repositories using a GET request. NOTE: Please make sure you include "repo" in your initial scope when requesting a token.
* Create a model for Repository and Owner.
* Create a HomeViewController and parse through the JSON returned from the server into models.
* Your HomeViewController should display all the repositories in a TableView.
* **Code Challenge:**
	* Write a function that takes in an array of numbers, and returns the lowest and highest numbers as a tuple.
* **Bonus**
	* Implement Pull-to-refresh on your Repository TableView.
	
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
