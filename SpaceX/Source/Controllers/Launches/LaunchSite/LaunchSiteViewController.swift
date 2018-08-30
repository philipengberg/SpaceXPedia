//
//  LaunchSiteViewController.swift
//  SpaceX
//
//  Created by Philip Engberg on 23/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import MapKit

class LaunchSiteViewController: UIViewController {

    // MARK: - Variables

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    private let _view = LaunchSiteView()
    private let viewModel: LaunchSiteViewModel
    private let bag = DisposeBag()
    private lazy var listManager: ListDataManager = ListDataManager(tableView: self._view.tableView, dataPresenter: self, emptyData: self)

    // MARK: - Inits

    init(viewModel: LaunchSiteViewModel) {
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
        
        _view.tableView.registerCell(MapCell.self)
        _view.tableView.registerCell(RocketCell.self)
        
        viewModel.object.asObservable().unwrap() .take(1).subscribe(onNext: { (launchSite) in
            Analytics.trackLaunchSiteShown(for: launchSite)
        }).disposed(by: bag)
        
        viewModel.object.asObservable().unwrap().map { $0.location.name }.bind(to: self.rx.title).disposed(by: bag)
        
        viewModel.dataState.asObservable().subscribe(onNext: { [weak self] (dataState) in
            self?.listManager.state = .dictData(json: JSONDict())
        }).disposed(by: bag)
        
        viewModel.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = _view.tableView.indexPathForSelectedRow {
            _view.tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    private let regionRadius: CLLocationDistance = 1000

    deinit {
        print("Deinit \(type(of: self))")
    }
}

extension LaunchSiteViewController: EmptyDataType {
    var placeholderSubtitle: String { return "No data" }
}

extension LaunchSiteViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 4
        default:
            guard let launchSite = viewModel.object.value else { return 0 }
            return launchSite.vehiclesLaunched.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueCell(MapCell.self, indexPath: indexPath)
                guard let launchSite = viewModel.object.value else { return cell }
                
                let location = CLLocation(latitude: launchSite.location.latitude, longitude: launchSite.location.longitude)
                
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
                cell.mapView.setRegion(coordinateRegion, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.title = launchSite.fullName
                annotation.coordinate = location.coordinate
                cell.mapView.addAnnotation(annotation)
                
                cell.selectionStyle = .none
                
                return cell
                
            default:
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")
                
                guard let launchSite = viewModel.object.value else { return cell }
                
                switch indexPath.row {
                case 1:
                    cell.textLabel?.text = "Name"
                    cell.detailTextLabel?.text = launchSite.fullName
                case 2:
                    cell.textLabel?.text = "Status"
                    cell.detailTextLabel?.text = launchSite.status.displayName
                case 3:
                    cell.textLabel?.text = "Details"
                    cell.detailTextLabel?.text = launchSite.details
                    cell.detailTextLabel?.numberOfLines = 0
                default: break
                }
                
                cell.selectionStyle = .none
                return cell
            }
            
        default:
            let cell = tableView.dequeueCell(RocketCell.self, indexPath: indexPath)
            guard let launchSite = viewModel.object.value else { return cell }
            cell.configure(with: launchSite.vehiclesLaunched[indexPath.row], rocketType: Rocket.RocketType(humanReadableString: launchSite.vehiclesLaunched[indexPath.row]))
            cell.accessoryType = .disclosureIndicator
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return "Vehicles launched"
        default: return nil
        }
    }
}

extension LaunchSiteViewController: UITableViewDelegate {
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard indexPath.section == 1 else { return }
            guard let launchSite = viewModel.object.value else { return }
            Router.route(to: .rocketDetail(rocketId: Rocket.RocketType(humanReadableString: launchSite.vehiclesLaunched[indexPath.row]).rawValue)) // Hack
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0,0): return 300
        default: return UITableViewAutomaticDimension
        }
    }
}

extension LaunchSiteViewController: ListDataManagerDelegate {
    func separatorStyle() -> UITableViewCellSeparatorStyle {
        return .singleLine
    }
}
