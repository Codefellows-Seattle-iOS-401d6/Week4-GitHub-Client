#Week 4 - Class 1
##Homework
* Implement an OAuth workflow in your app that successfully lets the user authenticate with your app.
* Implement UserDefaults to store the authorization token, so it only does the OAuth process once.
* Create a Personal Project requirement sheet.
	* Specify the features of your app.
	* Rough Navigation Model.
* **Code Challenge:**
	* Given an array of ints of odd length, return a new array length 3 containing the elements from the middle of the array. The array length will be at least 3.
* **Bonus:**
	* Create a github service and implement a method that fetches repositories based on a search term.
	* Implement saving to Keychain instead of UserDefaults.

###Readings:
* Apple Documentation
  * Static UITableView’s
  * UISearchBar
  * Keychain
  * UIWindow
* Swift Programming Guide
  * Generics
  * Ternary Operator
* Programming Concepts
  * Big O

##Other Resources
* [Reading Assignments](../../Resources/ra-grading-standard/)
* [Grading Rubrics](../../Resources/)
* [Lecture Resources](lecture/)
* [Lecture Slides](https://www.icloud.com/keynote/000EtSMrX5WTirpvWCOKi-OSQ#Week4_Day1)


BIG O NotificationIN CS, big o notation is ueed to measure efficiency of algorithms.
The O stands for order.
N refers to the size of the data.  Big O refers to the worst case scenario.

The running time of any simple operation is considered constant time or O1.  things like setting properties, checking bools, simple math are constant.
Constant time efficiency = whooohooo.

An example of O(N) algorithm is for loop.
The loop executives N times.
The worst case is you have ot loop through N tmies to find the element.
The oepration of the for loop is conatnt time value check.  If na array of ints containts an integer, it'll be o(n).  Checking if the element you're inspecting is o(1).  

O(N^2) refers to any algortihm whose big O is the square of the input data set.
Ane xample of this would be nested for loop.
Let's say we are searching fo rduplicates in an array of Strings for each string in the array, we search through every other string ad check if the values are the same.  If we have 7 strings, this operation will run 49 times, 7^2.
This is considered highly inefficient.

O(log N)
Good rule of thumb, if your altoghumn cuts the data set in half for in step of the algo, you are probably working in O(log N)
O(log N) is great!  Even when you double your N, the worst case time to run the algo only increase by a small amount.  The classic example of this is a binary search tree.



Binary search tree works with a sorted input.

Custom URL scheme for app allows the app to be opened by other apps.
info.plist
select URL types toward bototm
click on the + button or - bototm left cornerRadiusfor URL schemes, give it the string yo uwant to be your URL scheme.  For example, if you type MyApp, the custom URL for your app will be MyApp://

Parsing Info w/URL
Often times and especially with OAUth, your apps URL will be called with extra paratmers.  Typically this is a token flag.

There is a method you can implement in your app delegate to intercept these URL calls

application:openURL:sourceApplication:annotation

OAUTH!

Authorization protocl - a set of rules that allows a third party website of rpap to access user's data without the user needing to share credentials.

OAuth Workflow
The user shows intent by attemping ac action from the consumer app to the service provider.

The app redirects the user to the service provider for authentication

The user gives permission to the service provider for all the actions the consumer should be able to do on his/her behalf (posting to their timeline, accessing their twitter photo)

The serivce provider returns the user to the consumer app, with a request taken.

The consumer sends the request token together with its secret key to the service provider in excahgen for an authentication token.
The use rperforms actions and passes the authentication token with each call to provew ho he is.

Client  --- Server
  <--Credentials-->
	<--Code-->
	<--Code/Code ID/Secret Code(1 of these is prob only needed.)-->
	<--Token-->

	The callback URL

	Entry point to app.
	Service provider perofmrs an HTTP redirect to get the user back to consumer app
	In addition to URL of app, the callback url will ahve autho code appended to it.  It is up to be your app to parse this out and use it in compelting the OAuth workflow.
	Apll apps can be launched from either another app or from the brwoser itself.

	HTTP & CLIENT/SERVER model

HTTP is a TCP/IP based communication protocol, that is used to deliver data (HTML files, image files, query resuts) on www.

Format of a request and response are very similar.
They are considered English-oriented and human readable.
Both start off with an intiail line.  The intiail lline is where the main differences are between requests and responses.
After the initail line, there can be zero or more header lines.
After teh header line is blnak line.
Finally you have optional message body.


a request line has 3 parts that are separated by spaces
1st part is method name (GET POST PUT DELETE)
2nd part is locap path.
3rd part is HTTP version being used.

A status line has 3 parts and they are separated by spcae.s
The first part is the version of HTTP being used.
The second part is ar esponse status code.
Last is an enlgish reason phrase describing the status
Request
GET /NFL /seahawks/tickets.html HTTP/1.1
Response
HTTP/1.1 404 Not Found

HTTP METHODS!
GET - most common.  retrieves whatever resource is tat the URL location.  browser history is just a history of all GET requests you've made.
POST - method used to request that server accepted data enclased in the request.  When yo utweet, you are using POST to create a new record.

DELETE - used to delete a resources
PUT - similar to POST, instead of creatin ga new record, you are updating a preexisting one.

HEADER LINES!
Header liens are one line per head adn they take teh format of: "Header - Name : value"

Header name is not case sensitive

As many spaces between name : vaue you wantHeader lines that begin with space or tab are a part of the last header line for easy multi line reading.

Specific headers.While the HTTP protocol itself does not requeire any headder fields to function, API services requiere certain header fields to eb set.  Good APIs will tell you eaxctly which header feields you need.

Content-Type header field is used to specify the nature of data in the body of the request.  Usually need to manually set this if you are doing a POST/PUT call.

AUtho header field can be used to pass credentials for protocected resources.  Usually an OAUth token.

Apple provided calsses we use to maek networkc alls will fill outmost of ht eheaders we need to make our request.

Message Body:

Any HTTP message may have a body after the header lines.
In a request, this is where the appropriate dita files are place din a POSTIn a response, this is where the rrequested resource is (HTML, JSON, XML)

Whenever there is a body, COntent-Type and Content-Lenghth are usually included in the header lines so the client can make sure everything came over the wire as intedned.

     <----Domain------------><---URI--->
http//www.michaelcropper.co.uk/seo-tools/uri-encoder-decoder-tool-for-seo?name=value

<--Query String---> starts with the ?  ^^


WEB APIS!
A way tofor parts of software to interface with other software.
Web APIS, what you will be working with, are defined as  a set of HTTP requests and response essages uaully in JSON or someitmes XML.

Most apps on your iPHone are just clients for a Web API (Facebook, Twitter, Insta, Spotify)

REST API
(Representational State Transfer) API.  Not a protocol, just an architectureal style.

Uniform interface - resourced based Endpoints htat are consisntent

Stateless - required state to handle the request is all contaiend with the request itself.  The seriver doesn't need to keep ttrack fo communication history

REST APIS!

Cacheable - responses must define themselves a scacheable
Client-Seriver - concerns of client and server are separated
Layered System - Client doesn't know or care if the seriver is connected to main seriver or a lod baldncing server.

Code on Demand(optional) - Servers can temporarily exntend or customize functionaliry of a client by transferring loc to them.

API CLIENT WORKFLOW!
CLIENT MAKES A REQUEST TO SERVIER AT SPECIFIC ENDPOINT.SERVER RECEIVES REQUEST, QUERYIES DB /GENERATES DATA, AND SENDS BACK TO RESPONSE.

CLIEnt checks the respond HTTP status code.

200 erange (good) client parases JSON rsponse into model objectsClient updates UI and state with newly acquired objects.

NSURLSession is highly asyncrhronous.  Required for HTTP protcols.

NSURLSession provides 2 ways of interacting with RESTFful services. with completion handlers (closure) or delegation.

All http requests made with NNSURLSession are considered tasks.  Task must run on a session (NSURLSession class)
3 ptypes of tasks:  Data tasks -receive and send data using NSdata objects in memory.  Upload tasks - send filse iwth background support.  Download tasks download w/ background support.

SETUP!

NSURLSession is initialized with NSURlSessionConfiguration.
NSURLSessionCofiguration has 3 ptypes: default session (disk based cache).
Ephermeral session - no disk based caching, everything in memory only (really a one time instance)

Background session - similar to default, except with separate process handles for all data transfers.

Configurations have many properties for customizations.  You can set max number of connections per host, timeout intervals, cellular access or wifi only, and http headier fields.

NSURLSession also has a sharedSession singleton available to use based on default session.

--- CREATE A GITIGNORE WITH XCODE (not gonna happen)

Google official xcode GITIGNOREAdd to Atom as a .GITIGNORE

Add somewhere:
## credentials
GoGoGitHub/Credentials.swift

and then git add git commit.
