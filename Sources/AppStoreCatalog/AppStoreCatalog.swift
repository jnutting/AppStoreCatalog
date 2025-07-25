// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct AppStoreCatalog {
    let productGroups: [ProductGroup]
    
    // Throws potential decoding errors from JSONDecoder
    public init(data: Data) throws {
        let collection = try JSONDecoder().decode(ProductGroupsCollection.self, from: data)
        productGroups = collection.productGroups
    }
}
