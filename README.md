# FoodTracker + FoodServer

An iOS app used to record delicious meals you've enjoyed, and a CRUD server which stores the information. Both were written using Swift.

**This was created during my time as a student at Code Chrysalis.**

## How It Works

A user can use the iOS app to upload a name, a photo, and a rating for any meals they may have enjoyed. This data is stored in a PostgresQL database. The uploaded information can also be viewed on a front-end, and new meals can be added there as well.

## Getting Started

Due to its dependence on Xcode, this app can only be used on macOS.

First, fork and clone this repository:

```sh
$ git clone https://github.com/[username]/swift-food-tracker.git
```

There are two steps to getting things working.

### FoodTracker Setup

Make sure you have [Swift 4](https://swift.org/getting-started/#installing-swift), [Xcode 9](https://developer.apple.com/xcode/), and [Kitura 2](https://www.kitura.io/en/starter/gettingstarted.html) installed.

Install [CocoaPods](https://cocoapods.org/):

```sh
$ sudo gem install cocoapods
```

Use CocoaPods to install app dependencies:

```sh
$ cd iOS/FoodTracker
$ pod install
```

Open the FoodTracker app in Xcode

```sh
$ open FoodTracker.xcworkspace/
```

### FoodServer Setup

Make sure you have [PostgreSQL](https://www.postgresql.org/) installed:

```sh
$ brew install postgresql
$ brew services start postgresql
```

Create a database called `FoodDatabase` to store the data:

```sh
$ createdb FoodDatabase
```

Generate the server Xcode project:

```sh
$ cd FoodServer
$ swift package generate-xcodeproj
$ open FoodServer.xcodeproj/
```

In the top-left corner of Xcode, you should see a small terminal icon which says `FoodServer-Package`. Click this icon, and select `FoodServer` from the dropdown menu. Select `My Mac` as the build target.

## Starting the App

You need to start the server first, then the iOS app. Both can be started by clicking the play button in the top-left corner of the Xcode window, or by using `⌘R`. When you launch the iOS app, make sure the build target is one of the iOS simulators, and not your personal iOS device.

Once the server and iOS app are running, you can add, edit, and delete meals inside the simulator. You can also view and add meals by opening http://localhost:8080/foodtracker.

## API Endpoints

This server offers three endpoints:

* GET /meals - get all of the meal data on the server
* POST /meals - add a new meal to the server
* GET /summary - get the names and ratings of the meals, without the very large photo data

## Testing

Tests are written using `xctest`.

Start the tests selecting `Test` from the `Product` menu, or by using `⌘U`.

## Contributing

Please feel free to contribute to this repository. Make a pull request!

## Acknowledgements

The iOS was written following the [Start Developing iOS Apps (Swift) tutorial](https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/).

The backend server was written using IBM's [Kitura Swift](https://www.kitura.io) framework.
