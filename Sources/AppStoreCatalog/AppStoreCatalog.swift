//
//  AppStoreCatalog.swift
//  AppStoreCatalog
//
//  Created by Jack Nutting on 2025-07-23.
//

import Foundation

public struct AppStoreCatalog {
    let productGroups: [ProductGroup]
    
    // Throws potential decoding errors from JSONDecoder.
    // Eliminates any occurrences of the  optional app ID to exclude, and eliminates any product groups with an empty product list.
    public init(data: Data, excluding appID: String? = nil) throws {
        let collection = try JSONDecoder().decode(ProductGroupsCollection.self, from: data)
        productGroups = collection.productGroups.map { group in
            return ProductGroup(title: group.title,
                                products: group.products.filter { $0.id != appID })
        }
        .filter { !$0.products.isEmpty }
    }
}
