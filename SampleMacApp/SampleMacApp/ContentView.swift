//
//  ContentView.swift
//  SampleMacApp
//
//  Created by Jack Nutting on 2025-08-02.
//

import AppStoreCatalog
import SwiftUI

struct ContentView: View {
    private let catalog: AppStoreCatalog?
    
    @State var presentingSheet = false

    init() {
        do {
            let catalogUrl = Bundle.main.url(forResource: "ExampleCatalog", withExtension: "json")!
            let data = try Data(contentsOf: catalogUrl)
            catalog = try AppStoreCatalog(data: data)
        } catch {
            catalog = nil
        }
    }

    var body: some View {
        if let catalog {
            VStack {
                Button("Show apps using sheet") {
                    presentingSheet = true
                }
            }
            .padding()
            .sheet(isPresented: $presentingSheet) {
                AppStoreCatalogView(catalog: catalog,
                                    enableCloseButton: true) { identifier, error in
                    print("AppStoreCatalogView failed to show App Store view for product \(identifier):\n\(error.localizedDescription)")
                }
            }
        } else {
            Text("Failed to initialize AppStoreCatalog!")
        }
    }
}

#Preview {
    ContentView()
}
