//
//  AppStoreCatalog.swift
//  AppStoreCatalog
//
//  Created by Jack Nutting on 2025-07-23.
//

import Foundation

/// A struct representing an array of product groups, each containing an array of products. See bottom of this file for corresponding JSON example.
/// Passing in an optional `excluding identifier` will discard one item from the catalog. This lets you e.g. host a single JSON resource somewhere containing a catalog of all your apps, and have the resulting catalog exclude the app it's running in by passing in the app's own identifier.
/// Each item within a product group must have a unique identifier. If you use duplicate identifiers, behavior is undefined (you will probably see some "empty cells" in the AppStoreCatalogView display).
/// Any empty product groups in the given will be left out from the resulting AppStoreCatalog.
public struct AppStoreCatalog {
    let productGroups: [ProductGroup]
    
    /// AppStoreCatalog initializer. This liminates any occurrences of the  optional app ID to exclude, and eliminates any product groups with an empty product array.
    /// Throws potential decoding errors from JSONDecoder.
    /// - Parameters:
    ///   - data: A Data instance containing JSON data describing the products and groups
    ///   - identifier: Optionally exclude a single identifier.
    public init(data: Data, excluding identifier: String? = nil) throws {
        let collection = try JSONDecoder().decode(ProductGroupsCollection.self, from: data)
        productGroups = collection.productGroups.map { group in
            return ProductGroup(title: group.title,
                                products: group.products.filter { $0.id != identifier })
        }
        .filter { !$0.products.isEmpty }
    }
}

/* Example JSON containing a couple of product groups, each with a number of products
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
 */
