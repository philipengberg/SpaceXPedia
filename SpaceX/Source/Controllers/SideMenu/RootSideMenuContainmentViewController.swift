//
//  RootSideMenuContainmentViewController.swift
//  SpaceX
//
//  Created by Philip Engberg on 09/09/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import SnapKit
import RxSwiftExt

class RootSideMenuContainmentViewController: UITabBarController {

    // MARK: - Variables

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    private let sideMenu = SideMenuViewController()
    private let bag = DisposeBag()
    private let overlayView = UIView().setUp {
        $0.backgroundColor = UIColor.black
        $0.alpha = 0.3
    }
    
    private var leftConstraint: Constraint?
    private var initialPosition: CGFloat = 0
    private var currentPosition: CGFloat = 0
    
    private let initialPosition2 = Variable<CGFloat>(0)
    private let currentPosition2 = Variable<CGFloat>(0)
    private let sideMenuOffset = Variable<CGFloat>(0)
    private let sideMenuPercentVisible = Variable<CGFloat>(0)
    
    private let panGestureRecognizer = UIPanGestureRecognizer()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        view.addSubview(overlayView)
        
        addChildViewController(sideMenu)
        view.addSubview(sideMenu.view)
        sideMenu.view.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(250)
            make.top.bottom.left.equalToSuperview()
            self.leftConstraint = make.left.equalToSuperview().constraint
        }
        sideMenu.didMove(toParentViewController: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(panGestureRecognizer)
        
        panGestureRecognizer.rx.event.filter { $0.state == .began }.map { [weak self] _ in
            return self?.currentPosition2.value ?? 0
        }.bind(to: initialPosition2).disposed(by: bag)
        
        let translationObservable = panGestureRecognizer.rx.event.filter { $0.state == .changed }.map { $0.translation(in: $0.view).x }
        
        Observable
            .combineLatest(initialPosition2.asObservable(), translationObservable)
            .map { $0 + $1 }
            .bind(to: currentPosition2)
            .disposed(by: bag)
            
        currentPosition2.asObservable()
            .map { Math.shiftNumberRange(value: $0, oldMin: -250, oldMax: 0, newMin: 0, newMax: 1) }
            .map { max(0, min($0, 1)) }
            .bind(to: sideMenuPercentVisible)
            .disposed(by: bag)
        
        sideMenuPercentVisible.asObservable().subscribe(onNext: { [weak self] (percent) in
            self?.leftConstraint?.update(offset: Math.shiftNumberRange(value: percent, oldMin: 0, oldMax: 1, newMin: -250, newMax: 0))
            self?.view.layoutIfNeeded()
            self?.overlayView.alpha = Math.shiftNumberRange(value: percent, oldMin: 0, oldMax: 1, newMin: 0, newMax: 0.3)
        }).disposed(by: bag)
        
        panGestureRecognizer.rx.event.filter { $0.state == .ended }
            .map { $0.velocity(in: $0.view).x < 0 ? -250 : 0 }
            .subscribe(onNext: { [weak self] (finalOffset) in
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                    self?.currentPosition2.value = finalOffset
                }, completion: nil)
            }).disposed(by: bag)
    }
    
    override func updateViewConstraints() {
        
        overlayView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        super.updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sideMenu.view.layer.shadowColor = UIColor.black.cgColor
        sideMenu.view.layer.shadowOffset = CGSize(width: 3, height: 0)
        sideMenu.view.layer.shadowOpacity = 0.3
        sideMenu.view.layer.shadowRadius = 10
    }

    deinit {
        print("Deinit \(type(of: self))")
    }
}
