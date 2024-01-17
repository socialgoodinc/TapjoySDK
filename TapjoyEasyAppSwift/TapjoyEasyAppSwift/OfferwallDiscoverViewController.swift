//
//  OfferwallDiscoverViewController.swift
//  TapjoyEasyAppSwift
//
//  Created by Luke Bowman on 29/03/2023.
//

import Foundation
import UIKit
import Tapjoy
import SwiftUI

class OfferwallDiscoverViewController : UIViewController, TJOfferwallDiscoverDelegate {
    
    @Binding var statusMessageLbl: String
    var offerwallDiscoverView = TJOfferwallDiscoverView()
    var coordinatorBridge: CoordinatorBridge!
    
    init(statusMessageLbl: Binding<String>) {
        self._statusMessageLbl = statusMessageLbl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(Color("OWDBackgroundColor"))
        coordinatorBridge.viewController = self
    }
    
    func onTapRequestViewController(placement: String, width: Int, height: Int) {
        statusMessageLbl = "Click Request"
        offerwallDiscoverView.clear()
        offerwallDiscoverView = TJOfferwallDiscoverView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        offerwallDiscoverView.delegate = self
        self.view.addSubview(self.offerwallDiscoverView)
        offerwallDiscoverView.request(placement)
    }
    
    func onTapClearViewController(){
        offerwallDiscoverView.clear()
    }
    
    func onTapResizeViewController(width: CGFloat, height: CGFloat) {
        offerwallDiscoverView.frame.size.height = height
        offerwallDiscoverView.frame.size.width = width
    }
    
    // MARK: TJDiscoverViewDelegate methods
    
    func requestDidSucceed(for view: TJOfferwallDiscoverView) {
        statusMessageLbl = "ReqeustDidSucceed"
    }
    
    func requestDidFail(for view: TJOfferwallDiscoverView, error: Error?) {
        guard let error = error else { return }
        statusMessageLbl = "RequestDidFail -  \(error.localizedDescription) "
    }
    
    func contentIsReady(for view: TJOfferwallDiscoverView) {
        statusMessageLbl = "contentIsReady"
    }
    
    func contentError(for view: TJOfferwallDiscoverView, error: Error?) {
        guard let error = error else { return }
        statusMessageLbl = "contentError \(error.localizedDescription)"
    }
}

struct OfferwallDiscoverViewControllerWrapper: UIViewControllerRepresentable  {
    
    @Binding var statusMessageLbl: String
    var coordinatorBridge: CoordinatorBridge

    class Coordinator: NSObject {
        let parent: OfferwallDiscoverViewControllerWrapper
        init(_ view: OfferwallDiscoverViewControllerWrapper) {
            self.parent = view
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> OfferwallDiscoverViewController {
        let viewController = OfferwallDiscoverViewController(statusMessageLbl: $statusMessageLbl)
        viewController.coordinatorBridge = coordinatorBridge
        return viewController
    }

    func updateUIViewController(_ uiViewController: OfferwallDiscoverViewController, context: Context) {
    }
}

class CoordinatorBridge: ObservableObject {
    var viewController: OfferwallDiscoverViewController!
}
