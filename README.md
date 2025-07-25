AppStoreCatalog
----

AppStoreCatalog implements a GUI for displaying multiple App Store products in a scrolling list.
By tapping on a product, the user is taken to a page where they can see more info about the app and
purchase it, using SKStoreProductViewController.

This project is a SwiftUI rewrite/replacement of an older package called [MultiProductViewer](https://github.com/jnutting/MultiProductViewer).

Background:
-----

This functionality was originally (in iOS 5 and iOS 6) implemented by SKStoreProductViewController
itself. You could just pass it your company identifier, and it would present all of your company's
products in a list, and let the user drill down to get more info and purchase apps. That functionality
was removed in iOS 7, so we wrote this class to add it back.

What it does:
-----

Not content with just imitating the old behavior, we've improved it by showing a larger icon, and
giving the user the ability to include a small piece of text for each app. In this way, you can
give a little more info on the list view. Also, we let you pick exactly which apps you want to show,
and group them together.

In the old Apple way of doing things, you would just provide a company identifier, and Apple would
do the rest. Since that's not really feasible from the client side using public APIs, here we're
requiring you to provide the list of apps you want to show, and provide four pieces of data for each
of them: A name, Apple identifier, icon URL, and a text string with additional descriptive content.
The configuration can be easily specified using JSON or a dictionary.

How it looks:
-----

![screenshot](https://raw.github.com/thoughtbot/MultiProductViewer/screens/screens/0_0_1.png)

Usage:
-----

Start off by importing this SPM package into your project in the usual way.

Then, create a JSON file with the following structure, containing information for the products you want to display:

```
{ "productGroups" : [
    {   "title" : "Awesome Games",
        "products" : [
            {
                "name" : "FlippyBit",
                "details" : "Party like it's 1979! Flippy Bit takes the great action of early 2014, and makes it look like it's on an old Atari.",
                "identifier" : "825459863",
                "imageURL" : "https://rebisoft.com/appicons/flippybit512.png"
            },
            {
                "name" : "Scribattle",
                "details" : "Put your finger-flicking abilities to the test in this all-but-forgotten 2009 App Store hit game!",
                "identifier" : "301618970",
                "imageURL" : "https://rebisoft.com/appicons/scribattle100.png"
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

Then, in your application, import this framework into the view where you want to display it:

```
import AppStoreCatalog
```

When you want to display the view, do something like this:
```
    let data = Data(url: URL("https://rebisoft.com/all_products.json")!)
    let catalog = AppStoreCatalog(data: data)
    ...
    AppStoreCatalogView(catalog: catalog)
```

See the included example application for full usage details.
