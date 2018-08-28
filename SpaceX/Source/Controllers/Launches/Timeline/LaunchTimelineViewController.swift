//
//  LaunchTimelineViewController.swift
//  SpaceX
//
//  Created by Philip Engberg on 26/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class LaunchTimelineViewController: UIViewController {

    // MARK: - Variables

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    private let _view = LaunchTimelineView()
    private let viewModel: LaunchTimelineViewModel
    private let bag = DisposeBag()
    private lazy var listManager: ListDataManager = ListDataManager(tableView: self._view.tableView, dataPresenter: self, emptyData: self)

    // MARK: - Inits

    init(viewModel: LaunchTimelineViewModel) {
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
        
        _view.tableView.registerCell(LaunchTimelineDayCell.self)
        _view.tableView.registerCell(LaunchTimelineMonthStartCell.self)
        _view.tableView.registerCell(LaunchTimelineLaunchCell.self)
        
        viewModel.dataState.asObservable().subscribe(onNext: { [weak self] (dataState) in
            self?.listManager.state = dataState
        }).disposed(by: bag)
        
        viewModel.reloadData()
    }

    deinit {
        print("Deinit \(type(of: self))")
    }
}

extension LaunchTimelineViewModel.RowType {
    
    var cellType: UITableViewCell.Type {
        switch self {
        case .emptyDay: return LaunchTimelineDayCell.self
        case .emptyMonthStart: return LaunchTimelineMonthStartCell.self
        default: return LaunchTimelineLaunchCell.self
        }
    }
    
    var staticHeight: CGFloat {
        switch self {
        case .emptyDay: return 16
        case .emptyMonthStart: return 33
        default: return 308
        }
    }
    
}

extension LaunchTimelineViewController: EmptyDataType {
    var placeholderSubtitle: String { return "No data" }
}

extension LaunchTimelineViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(viewModel.dataSource.value[indexPath.row].cellType, indexPath: indexPath)
        
        switch viewModel.dataSource.value[indexPath.row] {
        case .launch(let launch):
            guard let launchCell = cell as? LaunchTimelineLaunchCell else { return cell }
            launchCell.configure(with: launch)
            
        case .emptyMonthStart(let date):
            guard let emptyMonthStartCell = cell as? LaunchTimelineMonthStartCell else { return cell }
            emptyMonthStartCell.configure(with: date)
            
        default: break
        }
        
        cell.selectionStyle = .none
        return cell
    }
}

extension LaunchTimelineViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        Router.route(to: .launchDetail(launchId: "", launch: viewModel.filteredLaunches.value[indexPath.row]))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowType = viewModel.dataSource.value[indexPath.row]
        switch rowType {
        case .emptyDay: return 16
        case .emptyMonthStart: return 33
        case .launch(let launch):
            return LaunchTimelineLaunchCell.height(for: launch, constrainedTo: tableView.width)
        }
    }
}

extension LaunchTimelineViewController: ListDataManagerDelegate {
    func separatorStyle() -> UITableViewCellSeparatorStyle {
        return .none
    }
}
