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
    @Environment(ViewModel.self) var vm
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text(product.name)
                .font(.headline)
            HStack(spacing: 16) {
                AsyncImage(url: product.imageURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100, alignment: .topLeading)
                    } else if phase.error != nil {
                        Image(packageResource: "failedIcon-noalpha", ofType: "png")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100, alignment: .topLeading)
                    } else { // placeholder during load
                        ProgressView().progressViewStyle(.circular)
                                .frame(width: 100, height: 100)
                    }
                }
                .cornerRadius(16)
                
                if !vm.failedProducts.contains(product) {
                    Text(product.details)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.red.opacity(0.9))
                            .stroke(
                                Color.red,
                                style: StrokeStyle(
                                    lineWidth: 5,
                                    lineCap: .round,
                                    lineJoin: .miter,
                                    miterLimit: 0,
                                    dash: [5, 10],
                                    dashPhase: 0
                                )
                            )
                        
                        Text("App Store doesn't know this product")
                            .foregroundStyle(.white)
                            .padding(16)
                    }
                }
            }
            .frame(maxHeight: 120)
        }
        .padding(16)
        .onTapGesture {
            guard !vm.failedProducts.contains(product) else { return }

            vm.selectedProduct = product
        }
    }
}

#Preview {
    let product = Product(name: "Great Product", details: "This is such a cool app, you would not believe how amazing it is. This app will rock your world! This is such a cool app, you would not believe how amazing it is. This app will rock your world! This is such a cool app, you would not believe how amazing it is. This app will rock your world!", identifier: "12345678", imageURL: URL(string: "https://picsum.photos/200")!)
    ProductView(product: product)
        .environment(ViewModel())
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
