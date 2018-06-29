//
//  ListViewModel.swift
//  RxSwift_Part1
//
//  Created by shengling on 2018/6/13.
//  Copyright © 2018年 ShengLing. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct RepoSection: SectionModelType {
    var items: [Repo]
    
    init(original: RepoSection, items: [Repo]) {
        self.items = items
    }
    
    init(items: [Repo]) {
        self.items = items
    }
    
}

final class GroupedViewModel {
    
    var pagingFilter = CarsalePageModel()
    
    var more: Variable<Bool> = Variable<Bool>(false)
    
    var sections = BehaviorRelay<[RepoSection]>(value: [])
    
    
    
    init() {
        
    }
    
    func refresh(_ isRefresh: Bool = true) -> Observable<[RepoSection]> {
        pagingFilter.page = isRefresh ? 0 : (pagingFilter.page + 1)
        return Networking.default
            .request(RepoRouter.repos)
            .unwrapper()
            .skipWhile{ $0 == nil }
            .doOnNext{ (resp) in self.more.value = resp?.more ?? false }
            .mapArray(type: Repo.self)
            .map { $0.map { repo in RepoSection(items: [repo]) } }
            .doOnNext {
                if isRefresh {
                    self.sections.accept($0)
                } else {
                    let newValue = self.sections.value + $0
                    self.sections.accept(newValue)
                }
            }
    }
}
