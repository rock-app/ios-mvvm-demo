//
//  KeyBoard.swift
//  RxSwift_Part1
//
//  Created by shengling on 2018/6/11.
//  Copyright © 2018年 ShengLing. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class KeyBoard: ReactiveCompatible {
    
//    static let `default` = KeyBoard()
    
    var height: CGFloat = 0
    
    var heightObseverable: PublishSubject<CGFloat>
    
    init() {
        heightObseverable = PublishSubject<CGFloat>()
        NotificationCenter.default.addObserver(self, selector: #selector(heightChanged(_:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func heightChanged(_ noti: Notification) {
        if let frame = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            let frameHeight = UIScreen.main.bounds.size.height - frame.origin.y
            heightObseverable.onNext(frameHeight)
        }
    }
    
}

extension Reactive where Base: KeyBoard {
    var height: ControlProperty<CGFloat> {
        return ControlProperty<CGFloat>(values: base.heightObseverable, valueSink: Binder(base) { (target, height) in
            target.height = height
        })
    }
}
