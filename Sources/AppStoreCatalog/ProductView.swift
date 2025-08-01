//
//  ProductView.swift
//  AppStoreCatalog
//
//  Created by Jack Nutting on 2025-07-23.
//

import SwiftUI

let errorFillColor = Color(red: 0.8, green: 0.1, blue: 0.1, opacity: 0.95)
let errorStrokeColor = Color.red
let errorStrokeStyle = StrokeStyle(
    lineWidth: 5,
    lineCap: .round,
    lineJoin: .miter,
    miterLimit: 0,
    dash: [5, 10],
    dashPhase: 0
)

struct ProductView: View {
    let product: Product
    let failedIconURL = Bundle.module.url(forResource: "failedIcon", withExtension: "png")!
    @Environment(ViewModel.self) var vm
    @Environment(\.dismiss) var dismiss

    var body: some View {
        var storeKitFailure = vm.failedProducts.contains(product)
        
        VStack {
            Text(product.name)
                .font(.headline)
            
            ZStack {
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
                    
                    Text(product.details)
                }
                
                Group {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(errorFillColor)
                        .stroke(
                            errorStrokeColor,
                            style: errorStrokeStyle
                        )
                    
                    Text("A product with the identifier \"\(product.identifier)\" couldn't be found on the App Store.")
                        .foregroundStyle(.white)
                        .font(.callout)
                        .padding(16)
                }
                .opacity(storeKitFailure ? 1 : 0)
                .animation(.snappy)
                .scaleEffect(storeKitFailure ? CGSize(width: 1.0, height: 1.0) : .init(width: 1.2, height: 1.2))
                .animation(.snappy)
                
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
