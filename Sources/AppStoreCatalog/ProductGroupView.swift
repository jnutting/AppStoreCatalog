//
//  ProductGroupView.swift
//  AppStoreCatalog
//
//  Created by Jack Nutting on 2025-07-23.
//

import SwiftUI

struct ProductGroupView: View {
    let group: ProductGroup
    
    var body: some View {
        Text(group.title)
            .font(.title)
        ForEach(group.products) { product in
            ProductView(product: product)
        }
    }
}

#Preview {
    let group = ProductGroup(title: "Cool Group", products: [])
    ProductGroupView(group: group)
}
