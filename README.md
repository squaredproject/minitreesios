# Squared Minitrees Ipad App

How to download and build the squared IOS app.  
Only do this if necessary, it is better to download it from the app store
https://apps.apple.com/us/app/squared-mini/id1464956368?ls=1

## Ipad App Quick Start
* Connect ipad to internet 
* Install Squared Mini app from app store
* https://apps.apple.com/us/app/squared-mini/id1464956368?ls=1
* Turn on tree and wait for patterns to start 
* Open Settings->Wifi on ipad and connect to mini-tree wifi
* Open app and start interacting with the tree

## How to build Ipad App from source

## Pre-reqs
* Xcode
* Apple Developer Account (free version is fine) 
* Github.com account
* Install Cocoapads (Xcode library dependencies) https://guides.cocoapods.org/using/getting-started.html

## Installation Instructions
* Download source code from github
  * cd ~/Desktop; git clone ; https://github.com/squaredproject/minitreesios.git
* Install latest dependencies:
  * cd ~/Desktop/minitreesios; pod install ; pod update;
* Add your developer apple id to xcode and make a cert
  * Open Xcode
  * Go to Xcode->Preferences, and click on Accounts
  * Add your APPLE ID	             	  
  * Create iOS Development Certificate:
    * Click on 'Manage Certificates"
      * Add IOS Development Certificate	 
* Open minitrees project in Xcode
  * File->Open
  * Navigate to minitereesios dir
  * Open Minitrees.xcworkspace
  * Connect to the Ipad in the Build pulldown
  * Click top left arrow to "build" minitreees
  * If build succeeds, then connect ipad to computer
  * Go to top left header and set Device to new Ipad
  * Click Build again
  * Check app is built on ipad
  * Sometimes ipad will say "Third-Party Apps from Unidentified Developers cannot be opened"
* In this case, go to Settings > General > Profiles or Profiles & Device Management and click on developer name and hit Trust


NOTE: if you build the app yourself, you are creating a debug build that will install *** and run on any ios device.  BUT because it is not a trusted app, after 30 days, the build will stop working on the device and will just refuse to open.
BEST TO download verified and signed build from the app store 


## Github Releases & Tags
### 1.0 Release
    git checkout  1.0_release
    Stable version released on app store
    Dimming functionality


### 1.2 Release
    git checkout  2.0_release
    New welcome screen with slideshow of squared photos 
    Timeout function on control page - after 5 mins of inactivity, app will timeout back to welcome screen, tree returns to default patterns

