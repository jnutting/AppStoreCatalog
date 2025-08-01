//
//  ContentView.swift
//  SampleApp
//
//  Created by Jack Nutting on 2025-07-31.
//

import AppStoreCatalog
import SwiftUI

struct ContentView: View {
    @State var presentingSheet = false

    let catalog = try! AppStoreCatalog(data: Data(String(jsonString).utf8))

    var body: some View {
        VStack {
            Button("Show me the apps!") {
                presentingSheet = true
            }
        }
        .padding()
        .fullScreenCover(isPresented: $presentingSheet) {
            AppStoreCatalogView(catalog: catalog) { identifier in
                print("AppStoreCatalogView failed show App Store view for product \(identifier)")
            }
        }
    }
}

#Preview {
    ContentView()
}

let jsonString = """
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
            "name" : "Not a real app",
            "details" : "Tap on this to see what happens when we give StoreKit an invalid identifier and it can't show its page.",
            "identifier" : "111",
            "imageURL" : "https://rebisoft.com/appicons/flippybit512.png"
        },
        {
            "name" : "Another fake app",
            "details" : "This one doesn't even have a functioning image. You'll see the placeholder in use instead.",
            "identifier" : "222",
            "imageURL" : "https://awuefhaiwhfjasdjgoasdkjfa.com/a.png"
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
        {
            "name" : "Goldy",
            "details" : "Goldy is a web browser for iPhone, iPad, and iPod touch that offers one simple feature: Privacy.",
            "identifier" : "417317449x",
            "imageURL" : "https://rebisoft.com/_Media/screen_shot_2011-08-19_at_med.png"
        },
    ]
},
]}
"""
