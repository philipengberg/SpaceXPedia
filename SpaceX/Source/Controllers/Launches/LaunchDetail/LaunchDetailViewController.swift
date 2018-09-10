//
//  LaunchDetailViewController.swift
//  SpaceX
//
//  Created by Philip Engberg on 22/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class LaunchDetailViewController: UIViewController {

    // MARK: - Variables

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    private let _view = LaunchDetailView()
    private let viewModel: LaunchDetailViewModel
    private let bag = DisposeBag()
    private lazy var listManager: ListDataManager = ListDataManager(tableView: self._view.tableView, dataPresenter: self, emptyData: self)

    // MARK: - Inits

    init(viewModel: LaunchDetailViewModel) {
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
        
        viewModel.object.asObservable().unwrap().take(1).subscribe(onNext: { (launch) in
            Analytics.trackLaunchDetailShown(for: launch)
        }).disposed(by: bag)
        
        viewModel.object.asObservable().map { $0.first }.unwrap().map { $0.missionName }.bind(to: self.rx.title).disposed(by: bag)
        
        _view.tableView.registerCell(LaunchVideoCell.self)
        
        viewModel.dataState.asObservable().subscribe(onNext: { [weak self] (dataState) in
            self?.listManager.state = dataState
        }).disposed(by: bag)
        
        viewModel.sections.asObservable().subscribe(onNext: { [weak self] (_) in
            self?._view.tableView.reloadData()
        }).disposed(by: bag)
        
        viewModel.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = _view.tableView.indexPathForSelectedRow {
            _view.tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }

    deinit {
        print("Deinit \(type(of: self))")
    }
}

extension LaunchDetailViewController: EmptyDataType {
    var placeholderSubtitle: String { return "No data" }
}

extension LaunchDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + viewModel.sections.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        default: return viewModel.sections.value[section - 1].properties.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueCell(LaunchVideoCell.self, indexPath: indexPath)
            if let videoId = viewModel.object.value?.links?.youTubeVideoId {
                cell.configure(with: videoId)
            } else {
                cell.showEmpty()
            }
            return cell
            
        default:
            let property = viewModel.sections.value[indexPath.section - 1].properties[indexPath.row]
            let cell = UITableViewCell(style: property.longValueText ? .subtitle : .value1, reuseIdentifier: "UITableViewCell")
            cell.textLabel?.text = property.propertyName
            cell.detailTextLabel?.text = property.propertyValue
            cell.accessoryType = property.detail == nil ? .none : .disclosureIndicator
            cell.selectionStyle = property.detail == nil ? .none : .default
            
            if property.longValueText {
                cell.detailTextLabel?.numberOfLines = 0
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return nil
        default: return viewModel.sections.value[section - 1].sectionName
        }
    }
}

extension LaunchDetailViewController: UITableViewDelegate {
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let destination = viewModel.sections.value[indexPath.section - 1].properties[indexPath.row].detail else { return }
            Router.route(to: destination)
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 250
        default: return UITableViewAutomaticDimension
        }
    }
}

extension LaunchDetailViewController: ListDataManagerDelegate {
    func separatorStyle() -> UITableViewCellSeparatorStyle {
        return .singleLine
    }
}
