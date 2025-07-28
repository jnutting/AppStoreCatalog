//
//  AppStoreCatalogView.swift
//  AppStoreCatalog
//
//  Created by Jack Nutting on 2025-07-23.
//

import SwiftUI

public struct AppStoreCatalogView: View {
    let catalog: AppStoreCatalog
    
    public var body: some View {
        VStack {
            ForEach (catalog.productGroups) { group in
                ProductGroupView(group: group)
            }
            
        }
    }
    
    public init(catalog: AppStoreCatalog) {
        self.catalog = catalog
    }
}

#Preview {
    let jsonString = """
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
"""
    let data = Data(String(jsonString).utf8)
    let catalog = try! AppStoreCatalog(data: data)
    AppStoreCatalogView(catalog: catalog)
}
