[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fjnutting%2FAppStoreCatalog%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/jnutting/AppStoreCatalog)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fjnutting%2FAppStoreCatalog%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/jnutting/AppStoreCatalog)

AppStoreCatalog
----

AppStoreCatalog implements a GUI for displaying multiple App Store products in
a scrolling grid. By tapping on a product, the user is taken to a page where
they can see more info about the app, and optionally purchase it using
`SKStoreProductViewController`. In a narrow space like an iPhone, the grid is
shown as a single column. In a wider space such as an iPad, it will expand to
more columns.

This project is a SwiftUI rewrite/replacement of an older package called 
[MultiProductViewer](https://github.com/jnutting/MultiProductViewer).

Background:
-----

This functionality was originally (in iOS 5 and iOS 6) implemented by
`SKStoreProductViewController` itself. You could just pass it your company
identifier, and it would present all of your company's products in a list, and
let the user drill down to get more info and purchase apps. That functionality
was removed in iOS 7, so the AppStoreCatalog package was created to add it back.

What it does:
-----

Instead of just imitating the old behavior (which no one has seen in well over
a decade), AppStoreCatalog improves upon it by showing a larger icon, and giving
the user the ability to include a small piece of text for each app. It also lets
you pick exactly which apps you want to show, and group them together in any way
you like. This can be used to promote not only your own companies apps, but also
groups of apps belonging to clients or friends, or just any apps you like for
any reason :)

In the ancient way of doing things that `SKStoreProductViewController` used to
provide, you just provided a company identifier, and StoreKit did the rest.
Since that's not really feasible from the client side using public APIs,
AppStoreCatalog requires you to provide four pieces of data for each app you
want to show: A name, an App Store identifier, anicon URL, and a text string
containing a brief description.

The configuration can be easily specified using JSON data, as described later
in this document.

How it looks:
-----

Here's the iPhone layout, presented with `.sheet()`:
![screenshot](https://raw.githubusercontent.com/jnutting/AppStoreCatalog/refs/heads/main/Screens/iPhone-screenshot.png)

Here's the iPad layout, presented with `.fullScreenCover()`:
![screenshot](https://raw.githubusercontent.com/jnutting/AppStoreCatalog/refs/heads/main/Screens/iPad-screenshot.png)

Usage:
-----

Start off by importing this SPM package into your project in the usual way,
using [this URL](https://github.com/jnutting/AppStoreCatalog).

Then, create a JSON file with the following structure, containing information
for the products you want to display, as shown below. The images referenced
as URLs will be sized to fit a screen size of a 100-point square. Most screens
in use on modern devices have a pixel density of at least two pixels per point,
so it's recommended to use images that are roughly 200x200.

The JSON can be contained within your project or hosted on a server, it's up
to you.

```
{ "productGroups" : [
    {   "title" : "Awesome Games",
        "products" : [
            {
                "name" : "FlippyBit",
                "details" : "Party like it's 1979! Flippy Bit makes one of 2014's biggest mobile hits look like it's on an old Atari.",
                "identifier" : "825459863",
                "imageURL" : "https://rebisoft.com/appicons/flippybit512.png"
            },
            {
                "name" : "Pits of Death",
                "details" : "Find your way through a mysterious dungeon. Find the arrow and defeat the dragon before you fall into a pit!",
                "identifier" : "989109750",
                "imageURL" : "https://rebisoft.com/appicons/PitsOfDeathIcon128.png"
            },
        ]
    },
    {   "title" : "Other Apps",
        "products" : [
            {
                "name" : "Goldy",
                "details" : "Goldy is a web browser for iPhone, iPad, and iPod touch that offers one simple feature: Privacy.",
                "identifier" : "417317449",
                "imageURL" : "https://rebisoft.com/_Media/screen_shot_2011-08-19_at_med.png"
            },
        ]
    },
]}
```

In your application, import this framework into the view where you want to
display it:

```
import AppStoreCatalog
```

Prepare the catalog data somewhere:
```
    // In production code, please do better than just "try!" as shown in this
    // snippet! 
    let data = try! Data(contentsOf: Bundle.main.url(forResource: "ExampleCatalog", withExtension: "json")!)
    // ... or ...
    let data = Data(url: URL("https://sample.com/all_products.json")!)
    
    let catalog = try! AppStoreCatalog(data: data) 
```

When you want to display the view, do something like this:
```
    // assuming the existence of `@State var presentingSheet`...
    .sheet(isPresented: $presentingSheet) {
        AppStoreCatalogView(catalog: catalog) { identifier in
            print("AppStoreCatalogView failed to show App Store view for product \(identifier)")
        }
    }

```

It's also possible to choose whether or not `AppStoreCatalogView` will include a
close button, which is not typically necessary for presentation within a Sheet,
but is definitely useful for a full screen presentation. See the included
example application for full usage details and examples.

Additional notes
-----

Tapping on a displayed product will attempt to display StoreKit's purchase page
for that product. If the product's identifier is invalid or cannot be found on
the app store for any reason, a message will be displayed to the user. You can
also give `AppStoreCatalogView` a closure to be called whenever this happens, in
case you want to log this in some way.

Due to StoreKit limitations, every attempt to display a purchase page fails when
running in the Simulator, so you'll see the failure message for every product.
Run on a device to see it actually work.

AppStoreCatalog builds and runs on macOS, but it doesn't seem to function quite
correctly as of yet. This may be fixed in the future, but for now, consider the
macOS support here "experimental". Pull requests to improve this are welcome!
