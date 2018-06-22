//
//  ListViewModel.swift
//  RxSwift_Part1
//
//  Created by shengling on 2018/6/13.
//  Copyright © 2018年 ShengLing. All rights reserved.
//

import Foundation
import RxSwift

final class ListViewModel {
    
    var pagingFilter = CarsalePageModel()
    
    var more: Variable<Bool> = Variable<Bool>(false)
    
    init() {
        
    }
    
    func refresh(_ isRefresh: Bool = true) -> Observable<[Repo]> {
        pagingFilter.page = isRefresh ? 0 : (pagingFilter.page + 1)
        return Networking.default
            .request(RepoRouter.repos)
            .unwrapper()
            .doOnNext{ (resp) in self.more.value = resp?.more ?? false }
            .mapArray(type: Repo.self)
    }
}
