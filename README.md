#Shingo Events App for iOS

<h4><strong>Important!</strong></h4>
<p>This app uses cocoapods to install critical packages needed to make this app run. Because of this, when you import this repository into Xcode you must open the project from 'Shingo Events.xcworkspace'. If you open it from the regular .xcodeproj project file, it will not compile.</p>

<p>If you open the project from the correct project folder and it still does not compile, make sure you have cocoapods installed on your system, and in a terminal window move to the working directory you stored the project under and type "pod install".</p>

<h4><strong>App Structure</strong><h4>

This project is still <strong>very</strong> much under development. A final product has not yet been released. See the inline comments for help trying to understand the code.

This app uses the Alamofire and AlamofireImage packages to retrieve data from our back-end server, and uses SwiftyJSON to parse the json response.

Nearly all of the data and API call functions are handled within the AppData class. Once you are familiar with using Alamofire, the rest of the code should hopefully seem pretty straightforward.
