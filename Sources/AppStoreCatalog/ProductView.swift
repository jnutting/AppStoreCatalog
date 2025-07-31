//
//  ProductView.swift
//  AppStoreCatalog
//
//  Created by Jack Nutting on 2025-07-23.
//

import SwiftUI

struct ProductView: View {
    let product: Product
    let failedIconURL = Bundle.module.url(forResource: "failedIcon", withExtension: "png")!

    
    var body: some View {
        VStack {
            Text(product.name)
                .font(.headline)
            HStack(spacing: 16) {
                AsyncImage(url: product.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                        .frame(width: 100, height: 100, alignment: .topLeading)
                } placeholder: {
                    ZStack {
                        Image(packageResource: "failedIcon", ofType: "png")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100, alignment: .topLeading)
                        ProgressView().progressViewStyle(.circular)
                    }
                }
                .cornerRadius(16)
                Text(product.details)
            }
            .frame(maxHeight: 120)
        }
        .padding(16)
        .onTapGesture {
//            
        }
    }
}

#Preview {
    let product = Product(name: "Great Product", details: "This is such a cool app, you would not believe how amazing it is. This app will rock your world! This is such a cool app, you would not believe how amazing it is. This app will rock your world! This is such a cool app, you would not believe how amazing it is. This app will rock your world!", identifier: "12345678", imageURL: URL(string: "https://picsum.photos/200")!)
    ProductView(product: product)
}

fileprivate extension Image {
    init(packageResource name: String, ofType type: String) {
        #if canImport(UIKit)
        guard let path = Bundle.module.path(forResource: name, ofType: type),
              let image = UIImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(uiImage: image)
        #elseif canImport(AppKit)
        guard let path = Bundle.module.path(forResource: name, ofType: type),
              let image = NSImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(nsImage: image)
        #else
        self.init(name)
        #endif
    }
}
