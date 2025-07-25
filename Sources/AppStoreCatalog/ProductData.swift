//
//  ProductData.swift
//  AppStoreCatalog
//
//  Created by Jack Nutting on 2025-07-23.
//

import Foundation

struct Product: Codable, Identifiable {
    var id: String { identifier }
    
    let name: String
    let details: String
    let identifier: String
    let imageURL: URL
}

struct ProductGroup: Codable, Identifiable {
    var id: String { title }

    let title: String
    let products: [Product]
}

struct ProductGroupsCollection: Codable {
    let productGroups: [ProductGroup]
}
