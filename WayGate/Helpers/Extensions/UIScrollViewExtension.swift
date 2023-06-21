//
//  UIScrollViewExtension.swift
//  WayGate
//
//  Created by Nabeel Nazir on 21/06/2023.
//

import UIKit
private var actionKey: Void?

extension UIScrollView {
    var refresherAction: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &actionKey) as? () -> Void
        }
        set {
            objc_setAssociatedObject(self, &actionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func setUpRefresherControll(tintColor: UIColor, action: @escaping () -> Void) {
        refresherAction = action
        alwaysBounceVertical = true
        let refresher: UIRefreshControl = UIRefreshControl()
        refresher.tintColor = tintColor
        refreshControl = refresher
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        addSubview(refresher)
    }
    
    @objc private func loadData() {
        refreshControl?.beginRefreshing()
        refresherAction?()
    }
    
    public func stopRefresher() {
        refreshControl?.endRefreshing()
    }
}
