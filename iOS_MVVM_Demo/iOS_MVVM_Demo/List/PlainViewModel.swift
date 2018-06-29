//
//  PlainViewModel.swift
//  iOS_MVVM_Demo
//
//  Created by shengling on 2018/6/29.
//  Copyright © 2018 ShengLing. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class PlainViewModel {

    var array = BehaviorRelay<[Repo]>(value: [])
    
    init() {
        
    }
    
    func refresh() -> Observable<[Repo]> {
        return Networking.default.request(RepoRouter.repos)
            .unwrapper()
            .skipWhile { $0 == nil }
            .mapArray(type: Repo.self)
            .doOnNext { self.array.accept($0)}
    }
    
}
