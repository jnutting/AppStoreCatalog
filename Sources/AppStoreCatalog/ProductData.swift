//
//  ProductData.swift
//  AppStoreCatalog
//
//  Created by Jack Nutting on 2025-07-23.
//

import Foundation

struct Product: Codable, Identifiable, Hashable, Sendable {
    let name: String
    let details: String
    let identifier: String
    let imageURL: URL

    var id: String { identifier }
}

struct ProductGroup: Codable, Identifiable, Sendable {
    let title: String
    let products: [Product]

    var id: String { title }
}

struct ProductGroupsCollection: Codable, Sendable {
    let productGroups: [ProductGroup]
}
