//
//  StoreView.swift
//  AppStoreCatalog
//
//  Created by Jack Nutting on 2025-07-31.
//

import StoreKit
import SwiftUI

#if canImport(UIKit)
struct StoreView: UIViewControllerRepresentable {
    /// Identifier for an App Store product
    let productIdentifier: String
    /// Optional handler. It is called with a value of `true` if the store presentation succeeds, `false` if it fails (e.g. due to an invalid identifier)
    var dismissHandler: StoreViewDismissHandler
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<StoreView>) -> StoreViewController {
        return StoreViewController(identifier: productIdentifier, coordinator: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: StoreViewController, context: UIViewControllerRepresentableContext<StoreView>) {
    }
    
    public func makeCoordinator() -> StoreViewCoordinator {
        .init(dismissHandler: dismissHandler)
    }
}

class StoreViewController: UIViewController {
    private let productIdentifier: String
    private let coordinator: StoreViewCoordinator
    private var storeController: SKStoreProductViewController?
    
    init(identifier: String, coordinator: StoreViewCoordinator) {
        self.productIdentifier = identifier
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
            if let error = error {
                self.dismiss(animated: true)
                self.coordinator.productViewControllerDidFail(storeController)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let storeController = storeController else { return }
        
        present(storeController, animated: true)
    }
}

#elseif canImport(AppKit)
struct StoreView: NSViewControllerRepresentable {
    /// Identifier for an App Store product
    let productIdentifier: String
    /// Optional handler. It is called with a value of `true` if the store presentation succeeds, `false` if it fails (e.g. due to an invalid identifier)
    var dismissHandler: StoreViewDismissHandler
        
    func makeNSViewController(context: Context) -> some NSViewController {
        return StoreViewController(productIdentifier: productIdentifier, coordinator: context.coordinator)
    }

    func updateNSViewController(_ nsViewController: NSViewControllerType, context: Context) {
    }

    public func makeCoordinator() -> StoreViewCoordinator {
        .init(dismissHandler: dismissHandler)
    }
}

class StoreViewController: NSViewController {
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
        let params = [SKStoreProductParameterITunesItemIdentifier: identifier]

        storeController.loadProduct(withParameters: params) { success, error in
            if let error = error {
                self.dismiss(true)
                self.coordinator.productViewControllerDidFail(storeController)
            }
        }
    }
    
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        guard let storeController = storeController else { return }
        
        presentAsSheet(storeController)
    }
}

#endif


typealias StoreViewDismissHandler = ((Bool) -> Void)?

class StoreViewCoordinator: NSObject, SKStoreProductViewControllerDelegate {
    private let dismissHandler: StoreViewDismissHandler
    
    init(dismissHandler: StoreViewDismissHandler) {
        self.dismissHandler = dismissHandler
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        dismissHandler?(true)
    }

    func productViewControllerDidFail(_ viewController: SKStoreProductViewController) {
        dismissHandler?(false)
    }
}
