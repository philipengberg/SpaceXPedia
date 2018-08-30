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
    
    private let noDecimalsNumberFormatter = NumberFormatter().setUp {
        $0.numberStyle = .decimal
        $0.maximumFractionDigits = 0
    }
    
    private let decimalsNumberFormatter = NumberFormatter().setUp {
        $0.numberStyle = .decimal
        $0.maximumFractionDigits = 2
    }

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
        
        viewModel.object.asObservable().unwrap().subscribe(onNext: { [weak self] (roadster) in
            guard let s = self else { return }
            
            let normalStyle = SwiftRichString.Style {
                $0.font = UIFont.italicSystemFont(ofSize: 18)
                $0.paragraph = NSMutableParagraphStyle().setUp {
                    $0.minimumLineHeight = 30
                    $0.alignment = .center
                }
                $0.color = #colorLiteral(red: 0.337254902, green: 0.431372549, blue: 0.5843137255, alpha: 1)
            }
            
            let highlihgtStyle = SwiftRichString.Style {
                $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
                $0.traitVariants = .italic
            }
            
            let group = StyleGroup(base: normalStyle, ["highlight": highlihgtStyle])
            
            let text = "Elon’s 🚘 is currently <highlight>{earth_distance} km</highlight> away from 🌍 moving at about <highlight>{speed} km/h</highlight> 💨 It orbits the ☀️ every <highlight>{period} days</highlight> at a distance between <highlight>{periapsis}</highlight> and <highlight>{apoapsis} AUs</highlight> 📡 It weighs <highlight>{weight} kg</highlight> and has now spent <highlight>{duration} days</highlight> in space ✨"
                .replacingOccurrences(of: "{earth_distance}", with: s.noDecimalsNumberFormatter.string(from: roadster.earthDistanceKm as NSNumber)!)
                .replacingOccurrences(of: "{speed}", with: s.noDecimalsNumberFormatter.string(from: roadster.speed.kmh as NSNumber)!)
                .replacingOccurrences(of: "{period}", with: s.noDecimalsNumberFormatter.string(from: roadster.periodDays as NSNumber)!)
                .replacingOccurrences(of: "{periapsis}", with: s.decimalsNumberFormatter.string(from: roadster.periapsisAu as NSNumber)!)
                .replacingOccurrences(of: "{apoapsis}", with: s.decimalsNumberFormatter.string(from: roadster.apoapsisAu as NSNumber)!)
                .replacingOccurrences(of: "{weight}", with: s.noDecimalsNumberFormatter.string(from: roadster.launchMass.kilos as NSNumber)!)
                .replacingOccurrences(of: "{duration}", with: s.noDecimalsNumberFormatter.string(from: roadster.launchDate.daysAgo as NSNumber)!)
            
            self?._view.textLabel.attributedText = text.set(style: group)
        }).disposed(by: bag)
        
        viewModel.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        navigationController?.setNavigationBarHidden(true, animated: animated)
        Style.appearance.applyTranslucentNavigationBarAppearance(to: navigationController?.navigationBar)
    }

    deinit {
        print("Deinit \(type(of: self))")
    }
}
