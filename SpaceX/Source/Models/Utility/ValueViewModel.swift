//
//  ValueViewModel.swift
//  SpaceX
//
//  Created by Philip Engberg on 20/08/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import Foundation
import RxSwift

class ValueViewModel<T: Serialization> {
    let bag = DisposeBag()
    let dataState: Variable<DataState> = Variable(DataState.initialLoading)
    let object: Variable<T?> = Variable(nil)
    
    lazy var loadAction: APIAction = APIAction {[weak self] api -> Observable<Any> in
        guard let s = self else { return Observable.empty() }
        return api.request(s.target).filterSuccessfulStatusCodes().mapJSON()
    }
    
    let api: API
    private let target: SpaceXTarget
    init(api: API = SpaceXAPI, target: SpaceXTarget) {
        self.api = api
        self.target = target
        
        loadAction.elements.mapToModel(T.self).bind(to: object).disposed(by: bag)
        loadAction.mapState().bind(to: dataState).disposed(by: bag)
    }
    
    func reloadData() {
        self.loadAction.execute(api)
    }
}

class ValuesViewModel<T: Serialization> {
    let bag = DisposeBag()
    let dataState: Variable<DataState> = Variable(DataState.initialLoading)
    let object: Variable<[T]> = Variable([])
    
    lazy var loadAction: APIAction = APIAction {[weak self] api -> Observable<Any> in
        guard let s = self else { return Observable.empty() }
        return api.request(s.target).filterSuccessfulStatusCodes().mapJSON()
    }
    
    let api: API
    private let target: SpaceXTarget
    init(api: API = SpaceXAPI, target: SpaceXTarget) {
        self.api = api
        self.target = target
        
        loadAction.elements.mapToModels(T.self).bind(to: object).disposed(by: bag)
        loadAction.mapState().bind(to: dataState).disposed(by: bag)
    }
    
    func reloadData() {
        self.loadAction.execute(api)
    }
}
