//
//  ListDataManager.swift
//  SpaceX
//
//  Created by Philip Engberg on 20/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import UIKit

protocol EmptyDataType: PlaceholderDataType { }
protocol ErrorDataType: PlaceholderDataType { }

class ErrorData: ErrorDataType {
    var placeholderTitle: String? { return nil }
    var placeholderSubtitle: String { return "" }
    var placeholderImage: UIImage? {
        return UIImage(named: "blank-default")
    }
}

class WrongError: ErrorData {
    override var placeholderTitle: String? { return "Whoops, something went wrong" }
    override var placeholderSubtitle: String { return "Please try again" }
}

class UnauthorizedError: ErrorData {
    override var placeholderTitle: String? { return "Unauthorised access" }
    override var placeholderSubtitle: String { return "Sorry, it looks like you don’t have access to this content" }
}

class NoConnectionError: ErrorData {
    override var placeholderTitle: String? { return "AOS failed" }
    override var placeholderSubtitle: String { return "Please check your internet connection" }
}

class NotFoundError: ErrorData {
    override var placeholderTitle: String? { return "Page not found" }
    override var placeholderSubtitle: String { return "Sorry, this page doesn’t seem to exist anymore" }
}

typealias ListDataHandler = UITableViewDataSource & UITableViewDelegate

protocol ListDataManagerDelegate: class {
    func separatorStyle() -> UITableViewCellSeparatorStyle
}

extension ListDataManagerDelegate {
    func separatorStyle() -> UITableViewCellSeparatorStyle {
        return .singleLine
    }
}

struct ListDataManager {
    
    let loading = LoadingDataSource()
    let error   = PlaceHolderDataSource()
    let empty   = PlaceHolderDataSource()
    
    weak var dataPresenter: ListDataHandler?
    weak var emptyData: EmptyDataType?
    weak var tableView: UITableView?
    
    var state: DataState = .initialLoading {
        didSet {
            if let tableView = self.tableView {
                switch state {
                case .initialLoading:
                    tableView.dataHandler = loading
                    tableView.separatorStyle = loading.separatorStyle()
                case .error(let err):
                    tableView.dataHandler = error
                    tableView.separatorStyle = error.separatorStyle()
                    switch err {
                    case .unknown,
                         .server,
                         .serialization:
                        error.placeholderView.configure(data: WrongError())
                    case .unauthorized:
                        error.placeholderView.configure(data: UnauthorizedError())
                    case .noConnection:
                        error.placeholderView.configure(data: NoConnectionError())
                    case .notFound:
                        error.placeholderView.configure(data: NotFoundError())
                    }
                    tableView.reloadData()
                case .noData:
                    guard let emptyData = emptyData else {
                        tableView.dataHandler = dataPresenter
                        return
                    }
                    tableView.separatorStyle = empty.separatorStyle()
                    tableView.dataHandler = empty
                    empty.placeholderView.configure(data: emptyData)
                    tableView.reloadData()
                default:
                    tableView.separatorStyle = ((dataPresenter as? ListDataManagerDelegate)?.separatorStyle()) ?? .none
                    tableView.dataHandler = dataPresenter
                    tableView.reloadData()
                }
            }
        }
    }
    
    init(tableView: UITableView, dataPresenter: ListDataHandler, emptyData: EmptyDataType?) {
        self.tableView = tableView
        self.dataPresenter = dataPresenter
        self.emptyData = emptyData
        
        tableView.registerCell(LoadingCell.self)
        tableView.registerCell(UITableViewCell.self)
    }
}

extension UITableView {
    var dataHandler: ListDataHandler? {
        set {
            delegate    = newValue
            dataSource  = newValue
        }
        get {
            return nil
        }
    }
}

class SingleCellHandler: NSObject, ListDataHandler, ListDataManagerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(UITableViewCell.self, indexPath: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let headerHeight = tableView.tableHeaderView?.frame.height ?? 0.0
        let footerHeight = tableView.tableFooterView?.frame.height ?? 0.0
        return max(1, tableView.bounds.height - headerHeight - footerHeight - tableView.contentInset.top - tableView.contentInset.bottom)
    }
    
    func separatorStyle() -> UITableViewCellSeparatorStyle {
        return .none
    }
}

class LoadingDataSource: SingleCellHandler {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(LoadingCell.self, indexPath: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.separatorInset.left = tableView.width
        
        return cell
    }
}

class PlaceHolderDataSource: SingleCellHandler {
    let placeholderView = PlaceholderView()
    
    override init() {
        super.init()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // This is kinda stupid.
        // Since two different dataSources uses the UITableViewCell then they share the reused cell but not the placeholderView
        cell.contentView.subviews.first?.removeFromSuperview()
        cell.contentView.addSubview(placeholderView)
        
        placeholderView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        placeholderView.layoutIfNeeded()
        return cell
    }
}
