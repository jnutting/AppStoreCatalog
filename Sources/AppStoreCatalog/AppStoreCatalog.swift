//
//  AppStoreCatalog.swift
//  AppStoreCatalog
//
//  Created by Jack Nutting on 2025-07-23.
//

import Foundation

/**
 `AppStoreCatalog` is a struct representing an array of product groups, each containing an array of products.
 
 `AppStoreCatalog` must be initialized with a `Data` object containing JSON in a particular structure. The following example contains a couple of product groups, each with a number of products:
 
 ```json
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

 An optional parameter allows you to omit one item from the catalog. This lets you e.g. host a single JSON resource somewhere containing a catalog of all your apps, and have the resulting catalog exclude the app it's running in by passing in the app's own identifier.

 Each item within a product group must have a unique identifier, corresponding to the identifier used in the App Store for a particular product. If you use duplicate identifiers within a product group, behavior is undefined (you will probably see some "empty cells" in the ``AppStoreCatalogView`` display).

 Any empty product groups will be left out from the resulting AppStoreCatalog, including product groups that are made empty through omitting the `excluding` parameter.
 */
public struct AppStoreCatalog: Sendable {
    public enum DataError: Error {
        case emptyProductGroups
    }
    
    let productGroups: [ProductGroup]
    
    /// The initializer's `data` parameter must be a JSON object containing an array of "productGroups", each of which has a "title" and an array of "products", as shown in the ``AppStoreCatalog`` documentation. The initializer eliminates any occurrences of the optional `excluding` identifier, and eliminates any product groups with an empty product array.
    ///
    /// - Parameters:
    ///   - data: A Data instance containing JSON data describing the products and groups
    ///   - identifier: A single product identifier, which if present in `data` will be omitted from the catalog.
    ///
    /// - Throws: Any JSON parsing/decoding errors from JSONDecoder will be thrown. Also, after considering the optional `excluding` identifier and all any product groups containing an empty array of products, if there are no populated product groups remaining, an `AppStoreCatalog.DataError.emptyProductGroups` error will be thrown.
    public init(data: Data, excluding identifier: String? = nil) throws {
        let collection = try JSONDecoder().decode(ProductGroupsCollection.self, from: data)
        productGroups = collection.productGroups.map { group in
            return ProductGroup(title: group.title,
                                products: group.products.filter { $0.id != identifier })
        }
        .filter { !$0.products.isEmpty }
        guard !productGroups.isEmpty else {
            throw DataError.emptyProductGroups
        }
    }
}
