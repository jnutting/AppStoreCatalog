//
//  StoreView.swift
//  AppStoreCatalog
//
//  Created by Jack Nutting on 2025-07-31.
//

import StoreKit
import SwiftUI

#if canImport(UIKit)
typealias PlatformViewController = UIViewController
typealias PlatformViewControllerRepresentable = UIViewControllerRepresentable
#elseif canImport(AppKit)
typealias PlatformViewController = NSViewController
typealias PlatformViewControllerRepresentable = NSViewControllerRepresentable
#endif

struct StoreView: PlatformViewControllerRepresentable {
    /// Identifier for an App Store product
    let productIdentifier: String
    /// Error handler. It is called with a nil if StoreKit successfully presents a product page, or with a non-nil `SKError` if it fails to do so (e.g. due to an invalid identifier)
    var storePresentationResultHandler: StorePresentationErrorHandler
    
#if canImport(UIKit)
    func makeUIViewController(context: Context) -> StoreViewController {
        return StoreViewController(productIdentifier: productIdentifier, coordinator: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: StoreViewController, context: Context) {
    }
#elseif canImport(AppKit)
    func makeNSViewController(context: Context) -> StoreViewController {
        return StoreViewController(productIdentifier: productIdentifier, coordinator: context.coordinator)
    }

    func updateNSViewController(_ nsViewController: StoreViewController, context: Context) {
    }
#endif
    
    public func makeCoordinator() -> StoreViewCoordinator {
        .init(storePresentationResultHandler: storePresentationResultHandler)
    }
}

class StoreViewController: PlatformViewController {
    private let productIdentifier: String
    private let coordinator: StoreViewCoordinator
    private var storeController: SKStoreProductViewController?
    
    init(productIdentifier: String, coordinator: StoreViewCoordinator) {
        self.productIdentifier = productIdentifier
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storeController = SKStoreProductViewController()
        self.storeController = storeController
        
        storeController.delegate = coordinator
        let params = [SKStoreProductParameterITunesItemIdentifier: productIdentifier]

        storeController.loadProduct(withParameters: params) { success, error in
            if let error = error as? SKError {
                Task { @MainActor in
#if canImport(UIKit)
                    self.dismiss(animated: true)
#elseif canImport(AppKit)
                    self.dismiss(self)
#endif
                    self.coordinator.productViewControllerDidFail(storeController, error: error)
                }
            }
        }
    }
   
#if canImport(UIKit)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let storeController = storeController else { return }
        present(storeController, animated: true)
    }
#elseif canImport(AppKit)
    override func viewDidAppear() {
        super.viewDidAppear()
        guard let storeController = storeController else { return }
        presentAsSheet(storeController)
    }
#endif
}

typealias StorePresentationErrorHandler = ((SKError?) -> Void)

class StoreViewCoordinator: NSObject, SKStoreProductViewControllerDelegate {
    private let storePresentationErrorHandler: StorePresentationErrorHandler
    
    init(storePresentationResultHandler: @escaping StorePresentationErrorHandler) {
        self.storePresentationErrorHandler = storePresentationResultHandler
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        storePresentationErrorHandler(nil)
    }

    func productViewControllerDidFail(_ viewController: SKStoreProductViewController, error: SKError) {
        storePresentationErrorHandler(error)
    }
}
