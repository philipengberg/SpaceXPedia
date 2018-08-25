//
//  LaunchesViewController.swift
//  SpaceX
//
//  Created by Philip Engberg on 21/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import RxCocoa
import RxSwift
import RxSwiftExt
import UIKit

class LaunchesViewController: UIViewController {

    // MARK: - Variables

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    private let _view = LaunchesView()
    private let viewModel: LaunchesViewModel
    private let bag = DisposeBag()
    private lazy var listManager: ListDataManager = ListDataManager(tableView: self._view.tableView, dataPresenter: self, emptyData: self)
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Inits

    init(viewModel: LaunchesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = "Launches"
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
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3254901961, blue: 0.5254901961, alpha: 1)
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.03137254902, green: 0.3254901961, blue: 0.5254901961, alpha: 1)
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = "Search Launches"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        _view.tableView.registerCell(LaunchOverviewCell.self)
        
        viewModel.dataState.asObservable().subscribe(onNext: { [weak self] (dataState) in
            self?.listManager.state = dataState
        }).disposed(by: bag)
        
        viewModel.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = _view.tableView.indexPathForSelectedRow {
            _view.tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }

    deinit {
        print("Deinit \(type(of: self))")
    }
}

extension LaunchesViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchText.value = searchController.searchBar.text
        _view.tableView.reloadData()
    }
}

extension LaunchesViewController: EmptyDataType {
    var placeholderSubtitle: String { return "No data" }
}

extension LaunchesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return viewModel.filteredLaunches.value.count
        } else {
            return viewModel.object.value.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(LaunchOverviewCell.self, indexPath: indexPath)

        if isFiltering() {
            cell.configure(with: viewModel.filteredLaunches.value[indexPath.row])
        } else {
            cell.configure(with: viewModel.object.value[indexPath.row])
        }
        
//        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension LaunchesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering() {
            Router.route(to: .launchDetail(launchId: "", launch: viewModel.filteredLaunches.value[indexPath.row]))
        } else {
            Router.route(to: .launchDetail(launchId: "", launch: viewModel.object.value[indexPath.row]))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
}

extension LaunchesViewController: ListDataManagerDelegate {
    func separatorStyle() -> UITableViewCellSeparatorStyle {
        return .none
    }
}
