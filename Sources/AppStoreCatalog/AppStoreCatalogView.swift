//
//  AppStoreCatalogView.swift
//  AppStoreCatalog
//
//  Created by Jack Nutting on 2025-07-23.
//

import StoreKit
import SwiftUI

@Observable class ViewModel {
    var selectedProduct: Product? = nil
    var failedProducts = Set<Product>()
}

/// A view that shows a vertically scrolling grid of the contents of an AppStoreCatalog and lets the user tap one to open a corresponding App Store page using StoreKit. On narrow screens such as an iPhone, this will be a single-column grid, but the view will adapt to show more columns on wider screens.
/// Depending on how this view is displayed in an app, it may or may not be desirable to have a floating close button in the upper right corner to dismiss it. This can be enabled with the `enableCloseButton` parameter. 
/// If an optional ProductFailureHandler is passed to the initializer, it will be called if StoreKit can't successfully open a detail page for one of the identifiers in `catalog`. You might use this to log an error remotely, to make yourself aware that there's a problem.
public struct AppStoreCatalogView: View {
    public typealias ProductFailureHandler = ((String, SKError) -> Void)
    
    let catalog: AppStoreCatalog
    let enableCloseButton: Bool
    let productFailureHandler: ProductFailureHandler?

    @State private var vm = ViewModel()
    @Environment(\.dismiss) var dismiss

    /// AppStoreCatalog initializer
    /// - Parameters:
    ///   - catalog: A valid instance of AppStoreCatalog
    ///   - enableCloseButton: Set this to `true` to include a floating close button
    ///   - productFailureHandler: An optional closure to call in case of an error occuring with StoreKit
    public init(catalog: AppStoreCatalog,
                enableCloseButton: Bool = false,
                productFailureHandler: ProductFailureHandler? = nil) {
        self.catalog = catalog
        self.enableCloseButton = enableCloseButton
        self.productFailureHandler = productFailureHandler
    }

    public var body: some View {
        var showCloseButton = vm.selectedProduct == nil
        
        ZStack {
            VStack {
                ScrollView {
                    ForEach (catalog.productGroups) { group in
                        ProductGroupView(group: group)
                            .environment(vm)
                            .cornerRadius(16)
                    }
                }
                Spacer()
            }

            if let selectedProduct = vm.selectedProduct {
                StoreView(productIdentifier: selectedProduct.identifier) { error in
                    if let error {
                        productFailureHandler?(selectedProduct.identifier, error)
                        vm.failedProducts.insert(selectedProduct)
                    }
                    vm.selectedProduct = nil
                }
            }
            
            if (enableCloseButton) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                        .imageScale(.large)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(8)
                .opacity(showCloseButton ? 1 : 0)
                .animation(.default)
            }
        }
    }
}

#Preview {
    let jsonString = """
{ "productGroups" : [
    {   "title" : "Awesome Games",
        "products" : [
            {
                "name" : "FlippyBit",
                "details" : "Party like it's 1979! Flippy Bit takes the great action of early 2014, and makes it look like it's on an old Atari.",
                "identifier" : "825459863",
                "imageURL" : "https://rebisoft.com/appicons/flippybit512.png"
            },
            {
                "name" : "FlippyBit",
                "details" : "Party like it's 1979! Flippy Bit takes the great action of early 2014, and makes it look like it's on an old Atari.",
                "identifier" : "825459863x",
                "imageURL" : "https://rebisoft.com/appicons/flippybit512.png"
            },
            {
                "name" : "Scribattle",
                "details" : "Put your finger-flicking abilities to the test in this all-but-forgotten 2009 App Store hit game!",
                "identifier" : "301618970",
                "imageURL" : "https://rebisoft.com/appicons/scribattle100.png"
            },
        ]
    },
    {   "title" : "Other Apps",
        "products" : [
            {
                "name" : "Goldy",
                "details" : "Goldy is a web browser for iPhone, iPad, and iPod touch that offers one simple feature: Privacy.",
                "identifier" : "417317449",
                "imageURL" : "https://rebisoft.com/_Media/screen_shot_2011-08-19_at_med.png"
            },
            {
                "name" : "Goldy",
                "details" : "Goldy is a web browser for iPhone, iPad, and iPod touch that offers one simple feature: Privacy.",
                "identifier" : "417317449x",
                "imageURL" : "https://rebisoft.com/_Media/screen_shot_2011-08-19_at_med.png"
            },
        ]
    },
]}
"""
    let data = Data(String(jsonString).utf8)
    let catalog = try! AppStoreCatalog(data: data)
    AppStoreCatalogView(catalog: catalog)
        .environment(ViewModel())
}
