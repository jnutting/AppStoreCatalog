//
//  ProductGroupView.swift
//  AppStoreCatalog
//
//  Created by Jack Nutting on 2025-07-23.
//

import SwiftUI

#if canImport(UIKit)
let backgroundColor = Color(UIColor.systemBackground)
#elseif canImport(AppKit)
let backgroundColor = Color(NSColor.windowBackgroundColor)
#endif

struct ProductGroupView: View {
    let group: ProductGroup
    
    var body: some View {
        GroupBox {
            Text(group.title)
                .font(.title)
            LazyVGrid(columns: [.init(.adaptive(minimum: 300, maximum: 600), spacing: 8)],
                      spacing: 8) {
                ForEach(group.products) { product in
                    ProductView(product: product)
                        .background(backgroundColor)
                        .cornerRadius(16)
                }
            }
        }
    }
}

#Preview {
    let product1 = Product(name: "Great Product", details: "This is such a cool app, you would not believe how amazing it is. This app will rock your world! This is such a cool app, you would not believe how amazing it is. This app will rock your world! This is such a cool app, you would not believe how amazing it is. This app will rock your world!", identifier: "12345678", imageURL: URL(string: "https://picsum.photos/200")!)
    let product2 = Product(name: "Great Product", details: "This is such a cool app, you would not believe how amazing it is. This app will rock your world! This is such a cool app, you would not believe how amazing it is. This app will rock your world! This is such a cool app, you would not believe how amazing it is. This app will rock your world!", identifier: "12345678x", imageURL: URL(string: "https://picsum.photos/200")!)

    let group = ProductGroup(title: "Cool Group", products: [product1, product2])
    ProductGroupView(group: group)
        .environment(ViewModel())
}
