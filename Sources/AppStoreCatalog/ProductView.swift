//
//  ProductView.swift
//  AppStoreCatalog
//
//  Created by Jack Nutting on 2025-07-23.
//

import SwiftUI

struct ProductView: View {
    let product: Product
    
    var body: some View {
        Text(product.name)
    }
}

#Preview {
    let product = Product(name: "Great Product", details: "This is such a cool app, you would not believe how amazing it is. This app will rock your world!", identifier: "12345678", imageURL: URL(string: "https://picsum.photos/200")!)
    ProductView(product: product)
}
