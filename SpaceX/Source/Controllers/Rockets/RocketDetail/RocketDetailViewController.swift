//
//  RocketDetailViewController.swift
//  SpaceX
//
//  Created by Philip Engberg on 20/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import RxCocoa
import RxSwift
import RxSwiftExt
import UIKit

class RocketDetailViewController: UIViewController {

    // MARK: - Variables

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    private let _view = RocketDetailView()
    private let viewModel: RocketDetailViewModel
    private let bag = DisposeBag()
    private lazy var listManager: ListDataManager = ListDataManager(tableView: self._view.tableView, dataPresenter: self, emptyData: self)

    // MARK: - Inits

    init(viewModel: RocketDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func loadView() {
        view = _view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.object.asObservable().unwrap().subscribe(onNext: { [weak self] (rocket) in
            self?.title = rocket.name
        }).disposed(by: bag)
        
        _view.tableView.registerCell(RocketImageCell.self)
        
        viewModel.dataState.asObservable().subscribe(onNext: { [weak self] (dataState) in
            self?.listManager.state = dataState
        }).disposed(by: bag)
        
        viewModel.reloadData()
    }

    deinit {
        print("Deinit \(type(of: self))")
    }
}

extension RocketDetailViewController: EmptyDataType {
    var placeholderSubtitle: String { return "No data" }
}

extension RocketDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        default: return viewModel.rocketProperties(for: section).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueCell(RocketImageCell.self, indexPath: indexPath)
            cell.rocketImageView.image = viewModel.object.value?.type.image
            return cell
            
        default:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
            cell.textLabel?.text = viewModel.rocketProperties(for: indexPath.section)[indexPath.row].propertyName
            cell.detailTextLabel?.text = viewModel.rocketProperties(for: indexPath.section)[indexPath.row].propertyValue
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return nil
        case 1: return "Basic info"
        case 2: return "Engine"
        default: return nil
        }
    }
}

extension RocketDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 320
        default: return tableView.rowHeight
        }
    }
}

extension RocketDetailViewController: ListDataManagerDelegate {
    func separatorStyle() -> UITableViewCellSeparatorStyle {
        return .singleLine
    }
}
