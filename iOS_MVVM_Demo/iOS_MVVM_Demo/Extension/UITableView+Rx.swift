//
//  UITableView+Rx.swift
//  RxSwift_Part1
//
//  Created by shengling on 2018/6/15.
//  Copyright © 2018 ShengLing. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    
    var refresh: ControlEvent<Void> {
        return ControlEvent<Void>(events: Observable<Void>.create({ (anyObsever) -> Disposable in
            self.base.mj_header = MJRefreshNormalHeader {
                anyObsever.onNext(())
            }
            return Disposables.create()
        }))
    }
    var loadmore: ControlEvent<Void> {
        return ControlEvent<Void>(events: Observable<Void>.create({ (anyObsever) -> Disposable in
            self.base.mj_footer = MJRefreshBackStateFooter {
                anyObsever.onNext(())
            }
            return Disposables.create()
        }))
    }
    var footerHidden: Binder<Bool> {
        return Binder(base){ (base, isHidden) in
            base.mj_footer.isHidden = !isHidden
        }
    }
}
