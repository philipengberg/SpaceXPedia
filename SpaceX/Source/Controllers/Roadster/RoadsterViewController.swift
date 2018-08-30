//
//  RoadsterViewController.swift
//  SpaceX
//
//  Created by Philip Engberg on 30/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftRichString
import UIKit

class RoadsterViewController: UIViewController {

    // MARK: - Variables

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    private let _view = RoadsterView()
    private let viewModel: RoadsterViewModel
    private let bag = DisposeBag()
    
    private let normalStyle = SwiftRichString.Style {
        $0.font = UIFont.italicSystemFont(ofSize: 18)
        $0.paragraph = NSMutableParagraphStyle().setUp {
            $0.minimumLineHeight = 30
            $0.alignment = .center
        }
        $0.color = #colorLiteral(red: 0.337254902, green: 0.431372549, blue: 0.5843137255, alpha: 1)
    }
    
    private let highlihgtStyle = SwiftRichString.Style {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.traitVariants = .italic
    }
    
    private lazy var group = StyleGroup(base: normalStyle, ["highlight": highlihgtStyle])

    // MARK: - Inits

    init(viewModel: RoadsterViewModel) {
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
        
        let close = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-close"), style: .plain, target: nil, action: nil)
        close.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: bag)
        navigationItem.leftBarButtonItem = close
        
        viewModel.loadAction.executing.bind(to: _view.spinner.rx.isAnimating).disposed(by: bag)
        
        viewModel.roadsterDescription.asObservable().unwrap().subscribe(onNext: { [weak self] (description) in
            self?.updateView(with: description)
        }).disposed(by: bag)
        
        viewModel.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Style.appearance.applyTranslucentNavigationBarAppearance(to: navigationController?.navigationBar)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Analytics.trackRoadsterShown()
    }
    
    private func updateView(with text: String) {
        _view.textLabel.attributedText = text.set(style: group)
    }

    deinit {
        print("Deinit \(type(of: self))")
    }
}
