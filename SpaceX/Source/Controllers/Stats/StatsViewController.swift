//
//  StatsViewController.swift
//  SpaceX
//
//  Created by Philip Engberg on 31/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class StatsViewController: UIViewController {

    // MARK: - Variables

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    private let _view = StatsView()
    private let viewModel: StatsViewModel

    // MARK: - Inits

    init(viewModel: StatsViewModel = StatsViewModel()) {
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
    }

    deinit {
        print("Deinit \(type(of: self))")
    }
}
