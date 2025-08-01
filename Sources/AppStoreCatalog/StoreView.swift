//
//  StoreView.swift
//  AppStoreCatalog
//
//  Created by Jack Nutting on 2025-07-31.
//

import StoreKit
import SwiftUI
import UIKit

typealias StoreViewDismissHandler = ((Bool) -> Void)?

struct StoreView: UIViewControllerRepresentable {
    /// Identifier for an App Store product
    let identifier: String
    /// Optional handler. It is called with a value of `true` if the store presentation succeeds, `false` if it fails (e.g. due to an invalid identifier)
    var dismissHandler: StoreViewDismissHandler
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<StoreView>) -> StoreViewController {
        return StoreViewController(identifier: identifier, coordinator: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: StoreViewController, context: UIViewControllerRepresentableContext<StoreView>) {
    }
    
    public func makeCoordinator() -> StoreViewCoordinator {
        .init(dismissHandler: dismissHandler)
    }
}

class StoreViewController: UIViewController {
    private let identifier: String
    private let coordinator: StoreViewCoordinator
    private var storeController: SKStoreProductViewController?
    
    init(identifier: String, coordinator: StoreViewCoordinator) {
        self.identifier = identifier
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
                print("Error loading product view controller: \(error)")
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
