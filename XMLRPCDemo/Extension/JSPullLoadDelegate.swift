//
//  JSPullLoadDelegate.swift
//  Midar
//
//  Created by Kuldip Mac on 12/11/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import Foundation

import UIKit
import KRPullLoader


protocol JSPullLoadDelegate: KRPullLoadViewDelegate {
    var loadMoreView: KRPullLoadView? { get set }
    var tableView: UITableView! { get }
    
    func fetchDataOnScroll(_ completion: @escaping (() -> ()))
}


extension JSPullLoadDelegate where Self: UIViewController {
    func addRefreshView(_ action: Selector) {
        if tableView.refreshControl != nil { return }
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: action, for: .valueChanged)
    }
    func endRefreshView() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    func removeRefreshView() {
        tableView.refreshControl = nil
    }
    
    var canFetchMore: Bool {
        get { return loadMoreView != nil }
        set { newValue ? addLoader() : removeLoader() }
    }
    
    func removeLoader() {
        if let view = loadMoreView {
            tableView.removePullLoadableView(view)
            loadMoreView = nil
        }
    }
    func addLoader() {
        if self.loadMoreView != nil { return }
        self.loadMoreView = KRPullLoadView()
        self.loadMoreView?.isHidden = true
        self.loadMoreView?.delegate = self
        self.tableView.addPullLoadableView(self.loadMoreView!, type: .loadMore)
    }
    
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .loadMore {
            switch state {
            case let .loading(completionHandler):
                pullLoadView.isHidden = false
                
                if (tableView.refreshControl?.isRefreshing ?? false) {
                    completionHandler()
                    return;
                }
                
                self.fetchDataOnScroll(completionHandler)
            default: pullLoadView.isHidden = true
            }
        }
    }
}
