//
//  SideMenuViewController.swift
//  SpaceX
//
//  Created by Philip Engberg on 09/09/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class SideMenuViewController: UIViewController {

    // MARK: - Variables

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    private let _view = SideMenuView()
    private let viewModel: SideMenuViewModel

    // MARK: - Inits

    init(viewModel: SideMenuViewModel = SideMenuViewModel()) {
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
        
        _view.tableView.registerCell(SideMenuCell.self)
        _view.tableView.dataSource = self
        _view.tableView.delegate = self
        _view.tableView.contentInset.top = 44
    }

    deinit {
        print("Deinit \(type(of: self))")
    }
}

extension SideMenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(SideMenuCell.self, indexPath: indexPath)
        let item = viewModel.items[indexPath.row]
        cell.configure(type: item.type, name: item.name, selected: indexPath.row == viewModel.selectedIndex)
        cell.selectionStyle = .none
        return cell
    }
    
}

extension SideMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        WindowManager.shared.show(tab: viewModel.items[indexPath.row].tab)
        viewModel.selectedIndex = indexPath.row
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
}
